import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';

///客户发起约会-弹窗
class OrderCreateDialog extends StatelessWidget {
  const OrderCreateDialog._({super.key});

  static void show() {
    Get.dialog(
      const OrderCreateDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Wrap(
              spacing: -13.rpx,
              children: List.generate(2, (index) {
                return AppImage.asset(
                  "assets/images/mine/head_photo.png",
                  width: 60.rpx,
                  height: 60.rpx,
                );
              }),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: Text(
                "确定和Susie Jenkins发起约会？\n点击确定后系统将向其发送约会邀约。",
                textAlign: TextAlign.center,
                style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
              ),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "发起约会",
                onTap: () {
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
