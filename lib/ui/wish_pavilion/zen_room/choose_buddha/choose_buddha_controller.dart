import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/network.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'choose_buddha_state.dart';

class ChooseBuddhaController extends GetxController with GetAutoDisposeMixin {
  final ChooseBuddhaState state = ChooseBuddhaState();
  late final PageController pageController;
  late ScrollController scrollController;

  ChooseBuddhaController({
    required List<BuddhaModel> buddhaList,
    int? selectedId,
  }) {
    state.buddhaList.addAll(buddhaList);
    state.selectedIdRx.value = selectedId ?? state.buddhaList.first.id;
    final index =
        state.buddhaList.indexWhere((element) => element.id == selectedId);
    state.selectedIndex = max(index, 0);
    pageController = PageController(initialPage: state.selectedIndex);

    var initialScrollOffset = _computeScrollOffset(state.selectedIndex, 0) ?? 0;
    initialScrollOffset = max(0, initialScrollOffset - 36.rpx);
    scrollController = ScrollController(initialScrollOffset: initialScrollOffset);
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      final index = pageController.page?.round() ?? 0;
      if (index != state.selectedIndex) {
        state.selectedIndex = index;
        state.selectedIdRx.value = state.buddhaList[index].id;
        _scrollToTarget(index);
      }
    });
  }

  ///设置选中的佛像
  void setSelectedBuddha(BuddhaModel buddha) {
    final index =
        state.buddhaList.indexWhere((element) => element.id == buddha.id);
    if (index >= 0) {
      pageController.jumpToPage(index);
      state.selectedIndex = index;
      state.selectedIdRx.value = buddha.id;
    }
  }

  ///滚动到指定项
  void _scrollToTarget(int index) {
    var offset = _computeScrollOffset(index, scrollController.offset);
    if(offset != null){
      offset = min(offset, scrollController.position.maxScrollExtent);
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  ///计算需要滚动的offset,不需要滚动则返回null
  ///- index 佛像index
  ///- offset 当前的offset
  double? _computeScrollOffset(int index, double offset){
    final itemWidth = 82.rpx;
    final maxWidth = Get.width;
    final visibleCount = (maxWidth / itemWidth).floor();
    RangeValues range;
    if (index < visibleCount) {
      range = RangeValues(0, itemWidth * index);
    } else {
      range = RangeValues(
          (index - visibleCount + 1) * itemWidth, itemWidth * index);
    }
    double? newOffset;
    if (offset < range.start) {
      newOffset = range.start;
    } else if (offset > range.end) {
      newOffset = range.end;
    }
    return newOffset;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
