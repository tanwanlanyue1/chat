import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AppImage.asset(
              'assets/images/home/launch_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Text('276rpx ${276.rpx}'),
          Positioned(
            child: AppImage.asset(
              'assets/images/home/launch_image_1.png',
              width: 276.rpx,
              height: 554.rpx,
            ),
          ),
          Container(
            width: Get.width,
            height: Get.height,
            padding:
                FEdgeInsets(bottom: max(48.rpx, Get.mediaQuery.padding.bottom)),
            alignment: Alignment.bottomCenter,
            child: CommonGradientButton(
              onTap: () {
                Global.agreePrivacyPolicy()
                    .whenComplete(Get.navigateToHomeOrLogin);
              },
              width: 276.rpx,
              height: 42.rpx,
              text: '立即体验',
            ),
          )
        ],
      ),
    );
  }
}
