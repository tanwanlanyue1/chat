import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/wallet_controller.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

class WalletTopUpWidget extends StatelessWidget {
  WalletTopUpWidget({
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
              onTap: controller.onTapSubmitTopUp,
              title: "人工充值",
              buttonText: "点击立即前往提交订单",
            ),
            SizedBox(height: 24.rpx),
            _buildItem(
              onTap: controller.onTapSubmitOtherTopUp,
              title: "三方USDT充值",
              buttonText: "点击按钮立即前往第三方充值",
            ),
          ],
        ),
      ),
    );
  }

  Column _buildItem({
    required VoidCallback? onTap,
    required String title,
    required String buttonText,
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
          height: 68.rpx,
          margin: EdgeInsets.only(top: 16.rpx),
          padding: EdgeInsets.all(16.rpx),
          decoration: BoxDecoration(
            color: AppColor.scaffoldBackground,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: CommonGradientButton(
            onTap: onTap,
            text: buttonText,
            textStyle: AppTextStyle.st.size(12.rpx).textColor(Colors.white),
          ),
        ),
      ],
    );
  }
}
