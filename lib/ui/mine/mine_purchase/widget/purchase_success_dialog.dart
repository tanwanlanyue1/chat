import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/mine_purchase/widget/purchase_success_controller.dart';
import 'package:guanjia/widgets/app_image.dart';

class PurchaseSuccessDialog extends GetView<PurchaseSuccessController> {
  PurchaseSuccessDialog._({
    super.key,
    required this.goldNum,
  });

  int goldNum;

  static var _isVisible = false;

  static void show(int goldNum) async{
    if(!_isVisible){
      _isVisible = true;
      Get.dialog(PurchaseSuccessDialog._(goldNum: goldNum)).whenComplete(() => _isVisible = false);
      Future.delayed(2.seconds, (){
        if(_isVisible){
          Get.back();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseSuccessController>(
        init: PurchaseSuccessController(),
        builder: (controller) {
          return Container(
            alignment: Alignment.center,
            child: Container(
              width: 300.rpx,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.rpx),
                  AppImage.asset(
                    "assets/images/common/ic_success_dialog.png",
                    height: 90.rpx,
                    width: 120.rpx,
                  ),
                  SizedBox(height: 8.rpx),
                  Text(
                    "购买成功",
                    style: AppTextStyle.st.medium
                        .size(16)
                        .textColor(AppColor.gray5),
                  ),
                  SizedBox(height: 8.rpx),
                  Text.rich(
                    TextSpan(text: "您已成功充值", children: [
                      TextSpan(
                        text: " $goldNum ",
                        style: AppTextStyle.st.bold
                            .size(24.rpx)
                            .textColor(AppColor.primary),
                      ),
                      const TextSpan(text: "境修币"),
                    ]),
                    style: AppTextStyle.st.medium
                        .size(14.rpx)
                        .textColor(AppColor.gray9),
                  ),
                  SizedBox(height: 4.rpx),
                  Obx(() {
                    return Text.rich(
                      TextSpan(text: SS.login.info?.nickname ?? "", children: [
                        TextSpan(
                          text: "剩余境修币${SS.login.levelMoneyInfo?.money ?? ""}",
                          style: AppTextStyle.st.medium
                              .size(14.rpx)
                              .textColor(AppColor.gray9),
                        ),
                      ]),
                      style: AppTextStyle.st.medium
                          .size(14.rpx)
                          .textColor(AppColor.gray5),
                    );
                  }),
                  SizedBox(height: 16.rpx),
                ],
              ),
            ),
          );
        });
  }
}
