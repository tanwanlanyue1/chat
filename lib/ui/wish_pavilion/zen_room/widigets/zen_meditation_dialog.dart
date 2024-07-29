import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/zen_language_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///禅坐对话框
class ZenMeditationDialog extends StatelessWidget {
  final ZenLanguageModel model;
  const ZenMeditationDialog._({super.key, required this.model});

  static void show(ZenLanguageModel model) {
    Get.dialog(ZenMeditationDialog._(model: model));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 326.5.rpx,
          height: 449.rpx,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AppAssetImage(
                  'assets/images/wish_pavilion/zen_room/zen_meditation_dialog_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: FEdgeInsets(top: 45.rpx),
                child: Text(
                  model.title,
                  style: AppTextStyle.fs26b.copyWith(color: AppColor.gray5),
                ),
              ),
              Padding(
                padding: FEdgeInsets(vertical: 10.rpx),
                child: AppImage.asset(
                  'assets/images/wish_pavilion/zen_room/zen_meditation_dialog_divider.png',
                  height: 7.rpx,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: FEdgeInsets(horizontal: 48.rpx),
                  child: Text(
                    model.content,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs22b.copyWith(
                      color: AppColor.gray5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: FEdgeInsets(bottom: 92.rpx),
                child: buildButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button.icon(
          onPressed: Get.back,
          width: 90.rpx,
          height: 36.rpx,
          icon: AppImage.asset(
            'assets/images/wish_pavilion/zen_room/zen_meditation_close_btn.png',
          ),
        ),
        // Button.icon(
        //   width: 90.rpx,
        //   height: 36.rpx,
        //   margin: FEdgeInsets(left: 30.rpx),
        //   icon: AppImage.asset(
        //     'assets/images/wish_pavilion/zen_room/zen_meditation_share_btn.png',
        //   ),
        // ),
      ],
    );
  }
}
