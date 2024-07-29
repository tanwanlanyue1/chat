import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/chant_sutras_player_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/sutras_subtitle_utils.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:lrc/lrc.dart';

import 'chant_sutras_player_state.dart';
import 'widgets/chant_sutras_line_tile.dart';

class ChantSutrasPlayerPageController extends GetxController with GetAutoDisposeMixin {
  final ChantSutrasPlayerState state = ChantSutrasPlayerState();
  final scrollController = ScrollController();
  var maxHeight = 0.0;

  ///设置列表控件高度
  void setMaxHeight(double height){
    maxHeight = height;
  }

  BuddhistSutrasModel? _currentSutras;

  ChantSutrasPlayerController get chantSutrasController =>
      Get.find<ZenRoomController>().chantSutrasController;


  @override
  void onInit() {
    super.onInit();
    chantSutrasController.addListener(_onChantSutrasControllerChanged);
    _currentSutras = chantSutrasController.currentSutras;
    _initSubtitle(_currentSutras);

    autoCancel(chantSutrasController.positionStream.listen(_handleHighlight));
  }

  void _onChantSutrasControllerChanged(){
    if(chantSutrasController.currentSutras?.id != _currentSutras?.id){
      _currentSutras = chantSutrasController.currentSutras;
      _initSubtitle(_currentSutras);
    }
  }

  ///初始化字幕
  void _initSubtitle(BuddhistSutrasModel? currentSutras) async{
    print('初始化字幕');
    final subtitles = currentSutras?.subtitles ?? '';
    final content = currentSutras?.content ?? '';
    state.currentIndexRx.value = -1;
    state.linesRx.value = [];
    state.lrcRx.value = null;
    if(scrollController.hasClients){
      scrollController.position.jumpTo(0);
    }

    //是否有经文内容文件
    final hasContent = content.startsWith('http');
    //是否有音频字幕文件
    final hasSubtitles = subtitles.startsWith('http');
    if (!hasContent && !hasSubtitles) {
      return;
    }
    File? file;
    if(hasSubtitles){
      file = await SutrasSubtitleUtils.getSutrasContent(subtitles);
    }
    if(file == null && hasContent){
      file = await SutrasSubtitleUtils.getSutrasContent(content);
    }

    if(file == null || !(await file.exists())){
      return;
    }
    try{
      final content = await file.readAsString();
      final lrc = Lrc.parse(content.trim());
      state.lrcRx.value = lrc;
      state.linesRx.value = lrc.lyrics.map((e) => e.lyrics).toList();
    }catch(ex){
      state.linesRx.value = await file.readAsLines();
    }
  }

  ///处理LRC字幕高亮
  void _handleHighlight(Duration duration) {
    final lrc = state.lrcRx();
    if (lrc == null) {
      return;
    }

    var index = lrc.lyrics.length - 1;
    for(var i=0;i<lrc.lyrics.length;i++){
      final prev = lrc.lyrics.tryGet(i - 1);
      final item = lrc.lyrics[i];
      if(duration < item.timestamp && item.timestamp > (prev?.timestamp ?? Duration.zero)){
        index = i;
        break;
      }
    }
    _scrollRow(index);
  }

  void _scrollRow(int index){
    if(state.currentIndexRx.value == index || maxHeight <=0){
      return;
    }
    state.currentIndexRx.value = index;

      //中间行index
      final centerIndex = maxHeight / ChantSutrasLineTile.height ~/ 2;
      if(index < centerIndex){
        if(scrollController.offset > 0){
          scrollController.animateTo(0, duration: 100.milliseconds, curve: Curves.linear);
        }
        return;
      }

      final maxScrollExtent = scrollController.position.maxScrollExtent;
      var offset = ChantSutrasLineTile.height * index - (maxHeight/2);
      offset = max(0, offset);
      if(offset > maxScrollExtent){
        offset = maxScrollExtent;
      }
      scrollController.animateTo(offset, duration: 100.milliseconds, curve: Curves.linear);
  }

  @override
  void onClose() {
    chantSutrasController.removeListener(_onChantSutrasControllerChanged);
    super.onClose();
  }
}
