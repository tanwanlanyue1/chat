import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/widgets/loading.dart';

import '../widigets/merits_increment_view.dart';
import 'sutras_subtitles_view.dart';
import 'wooden_fish_state.dart';

class WoodenFishController extends GetxController with GetAutoDisposeMixin{
  final WoodenFishState state = WoodenFishState();
  final _beginTime = DateTime.now();
  final globalKey = GlobalKey<MeritsIncrementViewState>();

  late Soundpool _soundPool;

  ///木鱼声音ID
  late int _woodenFishSoundId;
  int? _woodenFishStreamId;

  ///僧磬声音ID
  late int _handbellSoundId;
  int? _handbellStreamId;

  ///页面UUID
  var _pageUuid = '';

  final _localStorage = LocalStorage('WoodenFish');
  final _kWoodenFishSetting = 'WoodenFishSetting';
  Timer? _autoKnockOnTimer;
  WoodenFishSetting? prevSetting;

  ///字幕控制器
  final subtitlesController = SutrasSubtitlesController();

  @override
  void onInit() {
    super.onInit();
    _initialize();
    _fetchData();
  }

  ///初始化音效
  void _initialize() async{
    _soundPool = Soundpool.fromOptions(options: const SoundpoolOptions(
      streamType: StreamType.music,
      maxStreams: 2,
    ));
    var data = await rootBundle.load('assets/audio/木鱼.mp3');
    _woodenFishSoundId = await _soundPool.load(data);
    data = await rootBundle.load('assets/audio/僧磬.mp3');
    _handbellSoundId = await _soundPool.load(data);

    //监听设置变更
    prevSetting = state.settingRx();
    autoDisposeWorker(ever(state.settingRx, (setting){
      if(setting.isAutoKnockOn){
        if(_autoKnockOnTimer == null || setting.frequency != prevSetting?.frequency){
          _autoKnockOnTimer?.cancel();
          _autoKnockOnTimer = Timer.periodic(Duration(milliseconds: (setting.frequency * 1000).toInt()), (timer) {
            knockOnWoodenFish();
          });
        }
      }else{
        _autoKnockOnTimer?.cancel();
        _autoKnockOnTimer = null;
      }
      prevSetting = setting;
      _localStorage.setJson(_kWoodenFishSetting, setting.toJson());
    }));

    final json = await _localStorage.getJson(_kWoodenFishSetting);
    if(json != null){
      state.settingRx.value = WoodenFishSetting.fromJson(json);
    }
  }

  void _fetchData() async{
    Loading.show();
    final responses = await Future.wait<ApiResponse>([
      WishPavilionApi.getPageUuid(0),
      WishPavilionApi.getTodayCount(),
      WishPavilionApi.getLastScriptures(),
    ]);
    Loading.dismiss();
    if (!responses.every((element) => element.isSuccess)) {
      responses
          .firstWhereOrNull((element) => !element.isSuccess)
          ?.showErrorMessage();
      return;
    }
    final pageUuidResp = responses[0] as ApiResponse<String>;
    _pageUuid = pageUuidResp.data ?? '';

    final statsResp = responses[1] as ApiResponse<TodayCultivationStatsModel>;
    state.statsRx.value = statsResp.data;

    final sutrasResp = responses[2] as ApiResponse<BuddhistSutrasModel?>;
    sutrasResp.data?.let(_setBuddhistSutras);
  }

  ///敲击僧磬
  void knockOnHandbell() async {
    final streamId = _handbellStreamId ?? 0;
    if(streamId > 0){
      _soundPool.stop(streamId);
    }
    _handbellStreamId = await _soundPool.play(_handbellSoundId);
    subtitlesController.next();
    state.currentKnockOnRx.value ++;
    globalKey.currentState?.incrementRandom();
  }

  ///敲击木鱼
  void knockOnWoodenFish() async{
    final streamId = _woodenFishStreamId ?? 0;
    if(streamId > 0){
      _soundPool.stop(streamId);
    }
    _woodenFishStreamId = await _soundPool.play(_woodenFishSoundId);
    subtitlesController.next();
    state.currentKnockOnRx.value ++;
    globalKey.currentState?.incrementRandom();
  }

  ///选择经书
  void onChooseBuddhistSutras() async{
    final data = await Get.toNamed(AppRoutes.buddhistSutrasListPage);
    if(data is BuddhistSutrasModel){
      _setBuddhistSutras(data);
    }
  }

  ///设置念诵的佛经
  void _setBuddhistSutras(BuddhistSutrasModel data) async{
    if(data.id != state.buddhistSutrasRx()?.id){
      state.buddhistSutrasRx.value = data;
      subtitlesController.setBuddhistSutras(data);
    }
  }

  ///提交本次敲击记录
  void _submit() async{
    if(state.currentKnockOnRx() > 0){

      //诵经信息
      final subtitles = subtitlesController.textItem;
      var scripturesId = 0;
      var completionRate = 0.0;
      if(subtitles != null && subtitles.progress > 0){
        scripturesId = state.buddhistSutrasRx()?.id ?? 0;
        completionRate = subtitles.progress / subtitlesController.total * 100;
      }

      await WishPavilionApi.saveRecitation(
        uuid: _pageUuid,
        count: state.currentKnockOnRx(),
        startTime: _beginTime.format,
        endTime: DateTime.now().format,
        scripturesId: scripturesId,
        completionRate: completionRate,
      );
    }
  }

  @override
  void onClose() {
    _submit();
    _soundPool.dispose();
    _autoKnockOnTimer?.cancel();
    _autoKnockOnTimer = null;
    super.onClose();
  }


}
