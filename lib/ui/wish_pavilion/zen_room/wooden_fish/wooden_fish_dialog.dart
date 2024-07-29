import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/chant_sutras_player/chant_sutras_player_view.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/merits_increment_view.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/zen_room_circle_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'sutras_subtitles_view.dart';
import 'wooden_fish_controller.dart';
import 'wooden_fish_state.dart';

///木鱼对话框
class WoodenFishDialog extends GetView<WoodenFishController> {
  const WoodenFishDialog._();

  WoodenFishState get state => controller.state;

  static void show() {
    Get.dialog(
      const WoodenFishDialog._(),
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: AppColor.gray7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WoodenFishController>(
      init: WoodenFishController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildAppBar(),
          body: Stack(
            children: [
              buildBody(),
              MeritsIncrementView(
                offset: Offset(Get.width/2-45.rpx, Get.height * 0.4),
                key: controller.globalKey,
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: Get.back,
        icon: AppImage.asset(
          'assets/images/common/ic_close_white.png',
          width: 24.rpx,
          height: 24.rpx,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(AppRoutes.woodenFishSettingPage);
          },
          icon: AppImage.asset(
            'assets/images/common/ic_setting_white.png',
            width: 24.rpx,
            height: 24.rpx,
          ),
        )
      ],
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Padding(
          padding: FEdgeInsets(top: 24.rpx),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildKnockOnStats(),
              Expanded(child: buildCurrentKnockOn()),
              Padding(
                padding: FEdgeInsets(right: 12.rpx),
                child: ZenRoomCircleButton(
                  onTap: controller.onChooseBuddhistSutras,
                  child: const Text('全部\n经书'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SutrasSubtitlesView(
            controller: controller.subtitlesController,
          ),
        ),
        buildFaQi(),
        ChantSutrasPlayerView(
          backgroundColor: AppColor.primary,
          isVisibleAll: false,
        ),
      ],
    );
  }

  ///敲击统计
  Widget buildKnockOnStats() {
    Widget buildItem(String text, int value) {
      return Container(
        width: 80.rpx,
        height: 50.rpx,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(12.rpx)),
          color: AppColor.brown7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyle.fs12m.copyWith(color: AppColor.gray3),
            ),
            Text(
              value.toString(),
              style: AppTextStyle.fs14b.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      final todayCount = state.todayKnockOnRx;
      final totalCount = state.totalKnockOnRx;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildItem('今日敲击', todayCount),
          Padding(
            padding: FEdgeInsets(top: 10.rpx),
            child: buildItem('累积敲击', totalCount),
          ),
        ],
      );
    });
  }

  ///本次敲击
  Widget buildCurrentKnockOn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style:
                AppTextStyle.fs18b.copyWith(color: Colors.white, height: 1.0),
            text: '本次敲击:',
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Obx(() {
                  return Text(
                    state.currentKnockOnRx().toString(),
                    style: AppTextStyle.fs30b
                        .copyWith(color: AppColor.gold, height: 1.0),
                  );
                }),
              ),
            ],
          ),
        ),
        Padding(
          padding: FEdgeInsets(top: 8.rpx),
          child: Text(
            '(可边敲法器边诵读经文)',
            style: AppTextStyle.fs12m.copyWith(color: AppColor.gray2),
          ),
        ),
      ],
    );
  }

  ///法器
  Widget buildFaQi() {
    Widget buildItem({required String icon, VoidCallback? onTap}) {
      return Container(
        width: 100.rpx,
        height: 100.rpx,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AppAssetImage(
                'assets/images/wish_pavilion/zen_room/法器底座.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: AnimatedScaleButton(
          onTap: onTap,
          child: AppImage.asset(icon, height: 70.rpx, fit: BoxFit.contain),
        ),
      );
    }

    return Padding(
      padding: FEdgeInsets(bottom: 54.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildItem(
            icon: 'assets/images/wish_pavilion/zen_room/僧磬.png',
            onTap: controller.knockOnHandbell,
          ),
          Obx(() {
            return Padding(
              padding: FEdgeInsets(left: 75.rpx),
              child: buildItem(
                icon: 'assets/images/wish_pavilion/zen_room/木鱼2.png',
                onTap: controller.state.settingRx().isAutoKnockOn
                    ? null
                    : controller.knockOnWoodenFish,
              ),
            );
          }),
        ],
      ),
    );
  }
}
