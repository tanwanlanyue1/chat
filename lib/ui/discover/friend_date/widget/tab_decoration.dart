import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

class TabDecoration extends Decoration {
  final int length;
  TabDecoration(this.length);
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TabPainter(onChanged,length);
  }
}

class _TabPainter extends BoxPainter {
  final int length;
  _TabPainter(super.onChanged,this.length);

  DecorationImagePainter? _imagePainter;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    _imagePainter ??= const DecorationImage(
        image: AppAssetImage('assets/images/plaza/friend_tab.png'),colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn))
        .createPainter(onChanged!);

    offset = offset.translate(0.rpx, 0.rpx);
    final rect = Rect.fromLTWH(length == 0 ? 6.rpx : offset.dx+20.rpx, offset.dy+24.rpx, 17.rpx, 6.rpx);
    _imagePainter!.paint(canvas, rect, null, configuration);
  }
}