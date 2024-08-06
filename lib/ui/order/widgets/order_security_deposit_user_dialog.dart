import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'package:guanjia/widgets/widgets.dart';

///客户缴纳保证金对话框
class OrderSecurityDepositUserDialog extends StatelessWidget {
  const OrderSecurityDepositUserDialog._({super.key});

  static void show() {
    Get.dialog(
      const OrderSecurityDepositUserDialog._(),
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
                "Susie Jenkins已同意您的邀约，\n请支付保证金和服务费。",
                textAlign: TextAlign.center,
                style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.scaffoldBackground,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
              ),
              margin: FEdgeInsets(horizontal: 16.rpx, top: 16.rpx),
              padding: EdgeInsets.all(24.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "服务费",
                        style:
                            AppTextStyle.fs14m.copyWith(color: AppColor.black6),
                      ),
                      Text(
                        "\$650",
                        style:
                            AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                      ),
                    ],
                  ),
                  Padding(
                    padding: FEdgeInsets(vertical: 16.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "保证金",
                          style: AppTextStyle.fs14m
                              .copyWith(color: AppColor.black6),
                        ),
                        Text(
                          "\$650",
                          style: AppTextStyle.fs14b
                              .copyWith(color: AppColor.primary),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: FEdgeInsets(top: 16.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "总计花费",
                          style: AppTextStyle.fs14m
                              .copyWith(color: AppColor.black6),
                        ),
                        Text(
                          "\$1300",
                          style: AppTextStyle.fs14b
                              .copyWith(color: AppColor.gray5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: FEdgeInsets(all: 16.rpx, top: 40.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: "去支付",
                onTap: (){
                  Get.back();
                  Loading.showToast('跳转订单支付');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
