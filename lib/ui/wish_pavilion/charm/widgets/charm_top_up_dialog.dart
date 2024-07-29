import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/app_color.dart';
import '../../../../common/app_text_style.dart';
import '../../../../common/routes/app_pages.dart';
import '../../../../widgets/app_image.dart';

class CharmTopUpDialog extends StatelessWidget {
  const CharmTopUpDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 326.rpx,
        height: 203.rpx,
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
              "assets/images/wish_pavilion/charm/dialog_top_up_bg.png"),
        ),
        child: Column(
          children: [
            SizedBox(height: 19.rpx),
            Text(
              "提示",
              style:
                  AppTextStyle.st.bold.size(18.rpx).textColor(AppColor.gray5),
            ),
            SizedBox(height: 24.rpx),
            Text(
              "境修币不足，您可前往充值页充值",
              style:
                  AppTextStyle.st.bold.size(14.rpx).textColor(AppColor.gray5),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Get.toNamed(AppRoutes.minePurchase);
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
                      "前往充值",
                      style: AppTextStyle.st.bold
                          .size(16.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 31.rpx),
          ],
        ),
      ),
    );
  }
}
