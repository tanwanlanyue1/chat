import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'package:guanjia/widgets/widgets.dart';

///缴纳保证金对话框
class SecurityDepositDialog extends StatelessWidget {
  const SecurityDepositDialog._({super.key});

  static Future<bool> show() async {
    final result = await Get.dialog<bool>(
      const SecurityDepositDialog._(),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        child: SizedBox(
          width: 311.rpx,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitleBar(),
              Padding(
                padding: FEdgeInsets(horizontal: 16.rpx, bottom: 24.rpx),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.securityDepositHint('${SS.appConfig.configRx()?.deposit ?? 0}元'),
                      style: AppTextStyle.fs16m.copyWith(
                        color: AppColor.gray5,
                        height: 24 / 16,
                      ),
                    ),
                    Padding(
                      padding: FEdgeInsets(top: 24.rpx),
                      child: CommonGradientButton(
                        height: 50.rpx,
                        text: S.current.depositNow,
                        onTap: depositNow,
                      ),
                    ),
                    Divider(
                      height: 32.rpx,
                      thickness: 1,
                      color: AppColor.grayF7,
                    ),
                    Text(
                      S.current.securityDepositTips,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.fs14m.copyWith(
                        color: AppColor.gray9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///立即缴纳
  void depositNow() async{
    final result = await PaymentPasswordKeyboard.show();
    if(result != null){
      Get.back(result: true);
    }
  }

  Widget buildTitleBar() {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.close, color: AppColor.gray5),
        onPressed: Get.back,
      ),
    );
  }

}
