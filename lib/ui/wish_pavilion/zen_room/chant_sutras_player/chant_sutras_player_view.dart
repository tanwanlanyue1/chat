import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/chant_sutras_player_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../buddhist_sutras_list/widgets/buddhist_sutras_cover.dart';
import '../widigets/zen_room_sutras_playlist_bottom_sheet.dart';

///诵经播放器Mini视图
class ChantSutrasPlayerView extends GetView<ZenRoomController> {
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool isVisibleAll;
  final TextStyle? textStyle;

  ///诵经播放器
  ///- isVisibleAll 是否显示“所有”按钮
  const ChantSutrasPlayerView({
    super.key,
    this.backgroundColor,
    this.padding,
    this.constraints,
    this.isVisibleAll = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: chantSutrasController,
      builder: (_, child) => GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.chantSutrasPlayerPage);
        },
        child: buildPlayer(),
      ),
    );
  }

  ChantSutrasPlayerController get chantSutrasController =>
      controller.chantSutrasController;

  Widget buildPlayer() {
    final currentSutras = chantSutrasController.currentSutras;
    final constraints = this.constraints ?? BoxConstraints(minHeight: 64.rpx);
    if (currentSutras == null) {
      return ConstrainedBox(constraints: constraints);
    }
    final textStyle =
        this.textStyle ?? AppTextStyle.fs14m.copyWith(color: Colors.white);
    return Container(
      constraints: constraints,
      color: backgroundColor ?? AppColor.brown11,
      padding: padding ??
          FEdgeInsets(
            horizontal: 12.rpx,
            top: 12.rpx,
            bottom: max(12.rpx, Get.padding.bottom),
          ),
      child: Row(
        children: [
          buildSutrasCover(),
          Expanded(
            child: Padding(
              padding: FEdgeInsets(left: 8.rpx),
              child: Text(
                currentSutras.name,
                style: textStyle,
              ),
            ),
          ),
          Button.icon(
            width: 40.rpx,
            height: 40.rpx,
            icon: AppImage.asset(
              chantSutrasController.playing
                  ? 'assets/images/wish_pavilion/zen_room/ic_pause.png'
                  : 'assets/images/wish_pavilion/zen_room/ic_play.png',
              width: 24.rpx,
              height: 24.rpx,
              color: textStyle.color,
            ),
            onPressed: chantSutrasController.togglePlay,
          ),
          Button.icon(
            width: 40.rpx,
            height: 40.rpx,
            icon: AppImage.asset(
              'assets/images/wish_pavilion/zen_room/ic_playlist.png',
              width: 24.rpx,
              height: 24.rpx,
              color: textStyle.color,
            ),
            onPressed: () {
              ZenRoomSutrasPlaylistBottomSheet.show();
            },
          ),
          if (isVisibleAll)
            Button(
              height: 40.rpx,
              width: 40.rpx,
              backgroundColor: Colors.transparent,
              child: const Text('全部'),
              onPressed: () {
                Get.toNamed(AppRoutes.allSutrasPage);
              },
            )
        ],
      ),
    );
  }

  ///经书封面
  Widget buildSutrasCover() {
    final currentSutras = chantSutrasController.currentSutras;
    return RepeatAnimatedBuilder(
      isAnimating: chantSutrasController.playing,
      duration: const Duration(seconds: 10),
      lowerBound: 0,
      upperBound: 2 * pi,
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.rotate(angle: value, child: child);
      },
      child: Container(
        width: 36.rpx,
        height: 36.rpx,
        decoration: ShapeDecoration(
            shape: const CircleBorder(), color: Colors.grey.withOpacity(0.3)),
        clipBehavior: Clip.antiAlias,
        child: currentSutras != null
            ? FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                child: BuddhistSutrasCover(name: currentSutras.name),
              )
            : null,
      ),
    );
  }
}
