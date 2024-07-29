import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_background_preview/charm_background_preview_dialog.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_put_result/charm_put_result_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class CharmPutResultDialog extends StatelessWidget {
  final int lightNum;
  final int blessNum;
  final String imageUrl;
  final String perfectImageUrl;
  final String svga;
  final int milliseconds;
  final VoidCallback? onConfirm;

  CharmPutResultDialog({
    super.key,
    this.lightNum = 0,
    this.blessNum = 0,
    this.imageUrl = "",
    this.perfectImageUrl = "",
    this.svga = "",
    this.milliseconds = 1200,
    this.onConfirm,
  });

  final controller = Get.put(CharmPutResultController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CharmPutResultController>(
      builder: (controller) {
        return GestureDetector(
          onTap: controller.isAnimation.value
              ? null
              : () {
                  controller.clearState();
                  Get.back();
                  onConfirm?.call();
                },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Builder(builder: (context) {
                final cardHeight = 380.rh;
                final cardWidth = cardHeight * 26 / 38;
                return Container(
                  width: cardWidth,
                  height: cardHeight,
                  margin: FEdgeInsets(
                      bottom: 155.rpx + 60.rpx + Get.mediaQuery.padding.bottom),
                  child: AnimatedBuilder(
                    animation: controller.controller,
                    builder: (_, __) {
                      return Transform.scale(
                        scaleX: 1 - controller.animation.value,
                        child: Obx(() {
                          return Visibility(
                            visible: controller.isCardVisible.value,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                AppImage.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  align: Alignment.bottomCenter,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                  border: Border.all(
                                    color: const Color(0xFFFFBD2C),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x9CFFBD2C),
                                      blurRadius: 16.rpx,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      CharmBackgroundPreviewDialog(
                                          perfectImageUrl),
                                      useSafeArea: false,
                                    );
                                  },
                                  child: Container(
                                    height: 36.rpx,
                                    decoration: BoxDecoration(
                                      color: const Color(0x9932281E),
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(8.rpx),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "完美预览",
                                      style: AppTextStyle.st.bold
                                          .size(14.rpx)
                                          .textColor(Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                );
              }),
              Positioned(
                bottom: 155.rpx + 60.rpx + Get.mediaQuery.padding.bottom,
                child: AppImage.networkSvga(
                  svga,
                  width: Get.width,
                  height: Get.width / 750 * 1100,
                  repeat: false,
                  onStatusUpdate: (status) {
                    if (status == AnimationStatus.forward) {
                      Timer(Duration(milliseconds: milliseconds), () {
                        controller.startAnimation();
                      });
                    }
                  },
                ),
              ),
              Positioned(
                bottom: Get.mediaQuery.padding.bottom + 60.rpx,
                child: Obx(() {
                  if (controller.isAnimation.value) return const SizedBox();

                  final visible = lightNum != 0 || blessNum != 0;

                  final confirmWidget = Container(
                    width: 61.rpx,
                    height: 20.rpx,
                    decoration: BoxDecoration(
                        image: AppDecorations.backgroundImage(
                            "assets/images/wish_pavilion/charm/tip_button_bg.png")),
                    alignment: Alignment.center,
                    child: Text(
                      "确定",
                      style: AppTextStyle.st
                          .size(10.rpx)
                          .textColor(AppColor.gray5),
                    ),
                  );

                  if (!visible) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.rpx),
                      child: confirmWidget,
                    );
                  }

                  final isLight = lightNum > 0;
                  final isBless = blessNum > 0;

                  final light = isLight ? "开光*$lightNum次" : "";
                  final bless = isBless ? "加持*$blessNum次" : "";
                  final dot = (isLight && isBless) ? "、" : "";

                  final tip = "恭喜额外获奖：$light$dot$bless";

                  return Container(
                    width: 267.rpx,
                    height: 34.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                          "assets/images/wish_pavilion/charm/tip_bg.png"),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 18.rpx),
                        Expanded(
                            child: Text(
                          tip,
                          style: AppTextStyle.st
                              .size(10.rpx)
                              .textColor(Colors.white),
                        )),
                        confirmWidget,
                        SizedBox(width: 18.rpx),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
