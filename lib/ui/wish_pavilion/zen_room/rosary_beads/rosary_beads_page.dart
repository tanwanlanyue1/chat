import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/rosary_beads/rosary_beads_state.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/merits_increment_view.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'rosary_beads_controller.dart';

class RosaryBeadsPage extends GetView<RosaryBeadsController> {
  const RosaryBeadsPage({super.key});

  RosaryBeadsState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RosaryBeadsController>(
      init: RosaryBeadsController(),
      builder: (_) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: const Color(0xFF1A1615),
          appBar: buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        ObxValue((isReadyRx) {
          if (isReadyRx()) {
            return WebViewWidget(controller: controller.webViewController);
          } else {
            return Spacing.blank;
          }
        }, state.isReadyRx),
        Column(
          children: [
            Padding(
              padding: FEdgeInsets(
                  top: 24.rpx + Get.mediaQuery.padding.top + kToolbarHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildKnockOnStats(),
                  Expanded(child: buildCurrentKnockOn()),
                  SizedBox(width: 80.rpx),
                ],
              ),
            ),
            const Spacer(),
            buildBottomTools(),
          ],
        ),
        MeritsIncrementView(
          offset: Offset(Get.width * 0.40, 230.rpx),
          key: controller.globalKey,
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: AppBackButton.light(),
    );
  }

  /// 底部工具栏
  Container buildBottomTools() {
    Widget buildItem(String text, VoidCallback? onTap) {
      return Flexible(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 36.rpx,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: const Color(0xFF8D310F),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style:
                  AppTextStyle.st.medium.size(14.rpx).textColor(Colors.white),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(
        top: 48.rpx,
        bottom: 30.rpx + Get.mediaQuery.padding.bottom,
      ),
      child: Obx(() {
        final isExpanded = state.isExpandedRx();
        final isSoundEnabled = state.configRx().isSoundEnabled;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isExpanded) ...[
              buildItem(
                isSoundEnabled ? "声音" : "静音",
                () => controller.onTapSound(),
              ),
              SizedBox(width: 21.rpx),
              buildItem("背景", () => controller.onTapBackground()),
              SizedBox(width: 21.rpx),
              buildItem("款色", () => controller.onTapColor()),
              SizedBox(width: 12.rpx),
            ],
            if (!isExpanded) const Spacer(),
            buildExpandedIcon(!isExpanded),
          ],
        );
      }),
    );
  }

  Widget buildExpandedIcon(bool isExpanded) {
    return GestureDetector(
      onTap: state.isExpandedRx.toggle,
      child: AppImage.asset(
        isExpanded
            ? 'assets/images/wish_pavilion/zen_room/beads_left.png'
            : 'assets/images/wish_pavilion/zen_room/beads_right.png',
        width: 36.rpx,
        height: 36.rpx,
      ),
    );
  }

  /// 念珠统计
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
          buildItem('今日念珠', todayCount),
          Padding(
            padding: FEdgeInsets(top: 10.rpx),
            child: buildItem('累积念珠', totalCount),
          ),
        ],
      );
    });
  }

  /// 本次念珠
  Widget buildCurrentKnockOn() {
    return Container(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          style: AppTextStyle.fs18b.copyWith(color: Colors.white, height: 1.0),
          text: '本次念珠:',
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
    );
  }
}
