import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/welcome/privacy_dialog.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: FEdgeInsets(bottom: max(48.rpx, Get.mediaQuery.padding.bottom)),
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AppAssetImage('assets/images/home/launch_image.png'),
          ),
        ),
        child: Button.stadium(
          onPressed: PrivacyDialog.show,
          width: 156.rpx,
          height: 42.rpx,
          child: Text(
            "立即体验",
            style: AppTextStyle.fs18m.copyWith(
              color: AppColor.brown14,
            ),
          ),
        ),
      ),
    );
  }
}
