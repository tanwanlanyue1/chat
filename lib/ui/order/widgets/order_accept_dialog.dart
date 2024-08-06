import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';

///佳丽接单对话框
class OrderAcceptDialog extends StatelessWidget {
  const OrderAcceptDialog._({super.key});

  ///接单对话框
  ///- true接受， false拒绝
  static Future<bool?> show() {
    //Security deposit
    return Get.dialog<bool>(
      const OrderAcceptDialog._(),
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
                "同意和Susie Jenkins发起约会？",
                textAlign: TextAlign.center,
                style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
              ),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx, horizontal: 16.rpx),
              child: Text(
                "注：为保障权益，约会双方均需缴纳保证金，保证金在订单结束后将会原路退回。",
                style: AppTextStyle.fs12m.copyWith(
                  color: AppColor.gray9,
                  height: 18 / 12,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    backgroundColor: AppColor.gray9,
                    width: 120.rpx,
                    height: 50.rpx,
                    child: Text(
                      '拒绝',
                      style: AppTextStyle.fs16m,
                    ),
                  ),
                  CommonGradientButton(
                    width: 120.rpx,
                    height: 50.rpx,
                    text: "接单约会",
                    onTap: () {
                      Get.back(result: true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
