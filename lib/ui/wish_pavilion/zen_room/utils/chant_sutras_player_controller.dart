
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:guanjia/common/database/app_database.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/widgets/loading.dart';

///禅房-诵经 播放控制
class ChantSutrasPlayerController extends ChangeNotifier{
  final _audioPlayer = AudioPlayer();
  final _subscriptions = <StreamSubscription>[];

  final _localStorage = LocalStorage('ZenRoomChantSutras');
  final _kSutrasId = 'SutrasId';
  final _kLoopMode = 'LoopMode';

  ///当前播放的经文
  BuddhistSutrasModel? _currentSutras;

  late final _playlistDao = AppDatabase.instance.buddhistSutrasPlaylistDao;

  final _playlist = <BuddhistSutrasModel>[];

  final _audioSource = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: true,
  );

  ///播放模式
  LoopMode get loopMode => _audioPlayer.loopMode;

  ///切换播放模式
  Future<void> toggleLoopMode() async{
    switch(loopMode){
      case LoopMode.off:
      case LoopMode.all:
        await _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        await _audioPlayer.setLoopMode(LoopMode.off);
        break;
    }
    await _localStorage.setString(_kLoopMode, loopMode.name);
    notifyListeners();
  }

  ///上一曲
  Future<void> previous(){
    return _audioPlayer.seekToPrevious();
  }

  ///是否可以上一曲
  bool get hasPrevious => _audioPlayer.hasPrevious;

  ///下一曲
  Future<void> next(){
    return _audioPlayer.seekToNext();
  }

  ///是否可以下一曲
  bool get hasNext => _audioPlayer.hasNext;

  ///设置播放进度
  Future<void> seek(Duration position,{int? index}){
    return _audioPlayer.seek(position, index: index);
  }

  ///播放列表
  List<BuddhistSutrasModel> get playlist => _playlist;

  var _isInitialize = false;

  ///当前播放的经文
  BuddhistSutrasModel? get currentSutras => _currentSutras;

  bool get playing => _audioPlayer.playing && _audioPlayer.processingState != ProcessingState.completed;

  ///播放进度
  Duration get position => _audioPlayer.position;

  ///播放进度流
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  ///音频时长流
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Future<void> initialize() async{
    if(_isInitialize){
      return;
    }
    _isInitialize = true;
    final id  = await _localStorage.getInt(_kSutrasId);
    final mode  = await _localStorage.getString(_kLoopMode);
    final list = await _playlistDao.list();
    final loopMode = LoopMode.values.asNameMap()[mode] ?? LoopMode.off;
    await _audioPlayer.setLoopMode(loopMode);
    await _audioPlayer.setShuffleModeEnabled(false);
    await _audioPlayer.setAudioSource(_audioSource);

    if(list.isNotEmpty){
      _audioSource.addAll(list.map((it) => it.toAudioSource()).toList());

      _playlist..clear()..addAll(list);
      final index = _playlist.indexWhere((element) => element.id == id);
      if(index != -1){
        _currentSutras = _playlist[index];
        await _audioPlayer.seek(Duration.zero, index: index);
      }
      notifyListeners();
    }

    _subscriptions.add(_audioPlayer.currentIndexStream.listen((index) {
      if(index != null){
        _currentSutras = _playlist.elementAtOrNull(index);
        _currentSutras?.let((it){
          _localStorage.setInt(_kSutrasId, it.id);
        });
        notifyListeners();
      }
    }));

    _subscriptions.add(_audioPlayer.playerStateStream.listen((event){
      notifyListeners();
    }));
  }

  ///播放经文
  Future<void> play(BuddhistSutrasModel model) async{
    return _setCurrentSutras(model, true);
  }

  ///设置当前经文
  ///- model
  ///- play 是否播放
  Future<void> _setCurrentSutras(BuddhistSutrasModel model, bool play) async{
    if(!model.audio.startsWith('http')){
      Loading.showToast('该经书没有音频');
      return;
    }
    if(model.id == currentSutras?.id){
      if(!playing){
        if(_audioPlayer.processingState == ProcessingState.completed){
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play();
      }
      return;
    }

    _currentSutras = model;
    final index = _playlist.indexWhere((element) => element.id == model.id);
    if(index != -1){
      _playlist[index] = model;
      await _audioPlayer.seek(Duration.zero, index: index);
    }else{
      _playlist.insert(0, model);
      await _audioSource.insert(0, model.toAudioSource());
      await _audioPlayer.seek(Duration.zero, index: 0);
      await _playlistDao.save(model);
    }
    await _localStorage.setInt(_kSutrasId, model.id);
    if(play){
      await _audioPlayer.play();
    }

    notifyListeners();
  }

  ///切换播放，暂停
  Future<void> togglePlay() async{
    if(playing){
      return _audioPlayer.pause();
    }else{
      if(_audioPlayer.processingState == ProcessingState.completed){
        await _audioPlayer.seek(Duration.zero);
      }
      return _audioPlayer.play();
    }
  }

  ///删除播放列表中的经文
  Future<void> delete(BuddhistSutrasModel model) async{
    await _playlistDao.delete(model);
    final index = _playlist.indexWhere((el) => el.id == model.id);
    if(index != -1){
      _playlist.removeAt(index);
      await _audioSource.removeAt(index);
    }
    if(model.id == _currentSutras?.id){
      await _localStorage.remove(_kSutrasId);
      _currentSutras = null;
      if(_playlist.isNotEmpty){
        return _setCurrentSutras(_playlist.first, playing);
      }
    }
    if(_playlist.isEmpty){
      await _audioPlayer.stop();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    _subscriptions.clear();
    _audioPlayer.dispose();
    super.dispose();
  }
}

extension on BuddhistSutrasModel{
  AudioSource toAudioSource(){
    return AudioSource.uri(Uri.parse(audio));
  }
}