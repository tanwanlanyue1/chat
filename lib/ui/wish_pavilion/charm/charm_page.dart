import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_background_preview/charm_background_preview_dialog.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'charm_controller.dart';

class CharmPage extends StatelessWidget {
  CharmPage({super.key});

  final controller = Get.put(CharmController());
  final state = Get.find<CharmController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "请符法坛",
          style: AppTextStyle.st.size(18.rpx).textColor(Colors.white),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
          _buildQingfu(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      top: Get.mediaQuery.padding.top + kBottomNavigationBarHeight,
      bottom: Get.mediaQuery.padding.bottom,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Spacer(),
                Obx(() {
                  final info = state.charmInfo.value;
                  final model = state.charmRecord.value;

                  final cardHeight = 380.rh;
                  final cardWidth = cardHeight * 26 / 38;

                  return GestureDetector(
                    onTap: controller.onTapPutCharm,
                    child: SizedBox(
                      height: cardHeight,
                      width: cardWidth,
                      child: Visibility(
                        visible: model != null,
                        replacement: Image.asset(
                          "assets/images/wish_pavilion/charm/no_charm.png",
                          fit: BoxFit.fill,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFBD2C),
                            ),
                            borderRadius: BorderRadius.circular(8.rpx),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AppImage.network(
                                  model?.currentStateImageUrl ?? "",
                                  width: cardWidth,
                                  height: cardHeight,
                                  fit: BoxFit.cover,
                                  align: Alignment.bottomCenter,
                                  borderRadius: BorderRadius.circular(8.rpx),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      CharmBackgroundPreviewDialog(
                                          model?.perfectImageUrl ?? ""),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          _buildOperation(),
          _buildBottom(),
        ],
      ),
    );
  }

  Container _buildBottom() {
    return Container(
      height: 60.rpx,
      color: const Color(0x26FFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "assets/images/wish_pavilion/charm/qingfu.png",
            width: 50.rpx,
            height: 50.rpx,
          ),
          GestureDetector(
            onTap: () => controller.onTapCharmBackground(),
            child: Image.asset(
              "assets/images/wish_pavilion/charm/background.png",
              width: 50.rpx,
              height: 50.rpx,
            ),
          ),
          GestureDetector(
            onTap: () => controller.onTapMyCharm(),
            child: Image.asset(
              "assets/images/wish_pavilion/charm/me.png",
              width: 50.rpx,
              height: 50.rpx,
            ),
          ),
        ],
      ),
    );
  }

  /// 右上角请符按钮
  Widget _buildQingfu() {
    return Obx(() {
      final info = state.charmInfo.value;
      if (info == null) return Container();

      final isNotFree = info.cost != 0 && info.seconds != 0;
      return Positioned(
        top: Get.mediaQuery.padding.top + kBottomNavigationBarHeight - 8.rpx,
        right: 12.rpx,
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.onTapInvite,
              child: SizedBox(
                height: 70.rpx,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 50.rpx,
                      height: 50.rpx,
                      margin: EdgeInsets.only(top: 8.rpx),
                      decoration: BoxDecoration(
                        image: AppDecorations.backgroundImage(
                            "assets/images/wish_pavilion/charm/qingfu_bg.png"),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "请符",
                        style: AppTextStyle.st.bold
                            .size(16.rpx)
                            .textColor(Colors.white),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 58.rpx,
                        height: 21.rpx,
                        child: Visibility(
                          visible: isNotFree,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: AppDecorations.backgroundImage(
                                "assets/images/wish_pavilion/charm/gold_bg.png",
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/wish_pavilion/charm/item_gold.png",
                                  width: 14.rpx,
                                  height: 14.rpx,
                                ),
                                SizedBox(width: 2.rpx),
                                Baseline(
                                  baseline: 10.rpx, // 需要根据实际情况调整基线
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text("x${info.cost}",
                                      style: AppTextStyle.st.bold
                                          .size(10.rpx)
                                          .textColor(const Color(0xFFFFE6A7))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 56.rpx,
                        height: 19.rpx,
                        decoration: BoxDecoration(
                          image: AppDecorations.backgroundImage(
                              "assets/images/wish_pavilion/charm/time_bg.png"),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isNotFree ? "下次免费" : "本次免费",
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(const Color(0xFFE4A547)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50.rpx,
              child: Visibility(
                visible: isNotFree,
                child: Text(
                  CommonUtils.convertCountdownToHMS(info.seconds),
                  style: AppTextStyle.st.size(10.rpx).textColor(Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 背景
  Positioned _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        "assets/images/wish_pavilion/charm/bg.png",
        fit: BoxFit.cover,
      ),
    );
  }

  /// 创建操作
  Widget _buildOperation() {
    return Obx(() {
      final info = state.charmInfo.value;

      final currentCharm = state.charmRecord.value;

      return SizedBox(
        height: 155.rpx,
        child: Visibility(
            visible: currentCharm != null,
            child: Builder(builder: (context) {
              final record = currentCharm;

              if (info == null || record == null) {
                return const SizedBox.shrink();
              }

              final isNotLight = record.lightStatus == 0;
              final isNotBless = record.blessStatus == 0;

              final items = [
                {
                  "title": "${isNotLight ? "可" : "已"}\n开\n光",
                  "centerTitle": "开光",
                  "isCanOperation": isNotLight,
                  "count": info.lightCount,
                },
                {
                  "title": "${isNotBless ? "可" : "已"}\n加\n持",
                  "centerTitle": "加持",
                  "isCanOperation": isNotBless,
                  "count": info.blessCount,
                },
              ];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(2, (index) {
                  final item = items[index];
                  final isCanOperation = item["isCanOperation"] as bool;

                  return Row(
                    children: [
                      Text(
                        item["title"] as String,
                        style: AppTextStyle.st.bold.size(10.rpx).textColor(
                            isCanOperation
                                ? const Color(0xFFE4A547)
                                : AppColor.gray9),
                      ),
                      SizedBox(width: 10.rpx),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => controller.onTapOperation(
                                id: record.id, type: index),
                            child: Container(
                              width: 52.rpx,
                              height: 52.rpx,
                              decoration: BoxDecoration(
                                image: AppDecorations.backgroundImage(
                                  isCanOperation
                                      ? "assets/images/wish_pavilion/charm/state_ready.png"
                                      : "assets/images/wish_pavilion/charm/state_normal.png",
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item["centerTitle"] as String,
                                style: AppTextStyle.st.bold
                                    .size(14.rpx)
                                    .textColor(
                                      isCanOperation
                                          ? const Color(0xFFF2E2C2)
                                          : Colors.white,
                                    )
                                    .copyWith(
                                        shadows: isCanOperation
                                            ? [
                                                const Shadow(
                                                  color: Color(0xFFFF9D00),
                                                  blurRadius: 2,
                                                )
                                              ]
                                            : null),
                              ),
                            ),
                          ),
                          Container(
                            width: 60.rpx,
                            height: 18.rpx,
                            margin: EdgeInsets.only(top: 4.rpx),
                            decoration: BoxDecoration(
                              image: AppDecorations.backgroundImage(
                                isCanOperation
                                    ? "assets/images/wish_pavilion/charm/surplus_bg_ready.png"
                                    : "assets/images/wish_pavilion/charm/surplus_bg_normal.png",
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "剩余${item["count"]}次",
                              style: AppTextStyle.st.bold
                                  .size(10.rpx)
                                  .textColor(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              );
            })),
      );
    });
  }
}
