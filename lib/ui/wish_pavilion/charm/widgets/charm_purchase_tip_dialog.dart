import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/app_color.dart';
import '../../../../common/app_text_style.dart';
import '../../../../widgets/app_image.dart';

class CharmPurchaseTipDialog extends StatelessWidget {
  final String name;
  final int goldNum;
  final VoidCallback? onConfirm;
  const CharmPurchaseTipDialog({
    super.key,
    required this.name,
    required this.goldNum,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 326.rpx,
        height: 262.rpx,
        padding: EdgeInsets.symmetric(horizontal: 29.rpx),
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
              "assets/images/wish_pavilion/charm/dialog_payment_tip_bg.png"),
        ),
        child: Column(
          children: [
            SizedBox(height: 69.rpx),
            FittedBox(
              child: Text.rich(
                TextSpan(children: [
                  const TextSpan(text: "您将花费"),
                  TextSpan(
                    text: "$goldNum境修币",
                    style: AppTextStyle.st.bold
                        .size(14.rpx)
                        .textColor(AppColor.primary),
                  ),
                  TextSpan(text: "购买$name-灵符壁纸"),
                ]),
                style: AppTextStyle.st.bold
                    .size(14.rpx)
                    .textColor(const Color(0xFF3B2121)),
                maxLines: 1,
              ),
            ),
            SizedBox(height: 12.rpx),
            Text(
              "注意：购买后，壁纸将保存至您的相册。您可将其壁纸设置为手机壁纸，恭敬在心，心力感应效果更佳",
              style:
                  AppTextStyle.st.light.size(12.rpx).textColor(AppColor.gray30),
              maxLines: 3,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 121.rpx,
                    height: 39.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/wish_pavilion/charm/dialog_cancel.png",
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "取消",
                      style: AppTextStyle.st.bold
                          .size(16.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    onConfirm?.call();
                  },
                  child: Container(
                    width: 121.rpx,
                    height: 39.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/wish_pavilion/charm/dialog_confirm.png",
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "确定",
                      style: AppTextStyle.st.bold
                          .size(16.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 54.rpx),
          ],
        ),
      ),
    );
  }
}
