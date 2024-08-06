import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/wallet_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

class WalletWithdrawalWidget extends StatelessWidget {
  WalletWithdrawalWidget({
    super.key,
  });

  final controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(
            top: 24.rpx, bottom: Get.mediaQuery.padding.bottom + 24.rpx),
        child: Column(
          children: [
            _buildItem(
              title: "提现到：",
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.5.rpx)
                  .copyWith(top: 36.rpx, bottom: 16.rpx),
              child: CommonGradientButton(
                onTap: controller.onTapSubmitTransfer,
                height: 50.rpx,
                text: "立即提现",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "我已成功提现，刷新余额",
                  style:
                      AppTextStyle.st.size(12.rpx).textColor(AppColor.black9),
                ),
                SizedBox(width: 8.rpx),
                AppImage.asset(
                  "assets/images/wallet/reload.png",
                  length: 16.rpx,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildItem({
    required String title,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 4.rpx,
              height: 20.rpx,
              margin: EdgeInsets.only(right: 8.rpx),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(2.rpx),
              ),
            ),
            Text(
              title,
              style: AppTextStyle.st.medium
                  .size(16.rpx)
                  .textColor(AppColor.black3),
            ),
          ],
        ),
        Container(
          height: 46.rpx,
          margin: EdgeInsets.only(top: 16.rpx),
          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
          decoration: BoxDecoration(
            color: AppColor.scaffoldBackground,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: Row(
            children: [
              Text(
                "支付宝",
                style: AppTextStyle.st.medium
                    .size(14.rpx)
                    .textColor(AppColor.black6),
              ),
            ],
          ),
        ),
        Container(
          height: 46.rpx,
          margin: EdgeInsets.only(top: 16.rpx),
          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
          decoration: BoxDecoration(
            color: AppColor.scaffoldBackground,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: Row(
            children: [
              Text(
                "提现金额：100 USDT",
                style: AppTextStyle.st.medium
                    .size(14.rpx)
                    .textColor(AppColor.black6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
