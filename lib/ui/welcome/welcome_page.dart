import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  static List<_SwiperItem> get _items {
    return [
      _SwiperItem(
        background: 'assets/images/home/launch_image_1.jpg',
        title: '安全稳定后宫',
        desc: '打造安全稳定后宫，汇集全球佳丽资源，提供隐秘支付方式，搭配完美成人生活。',
      ),
      _SwiperItem(
        background: 'assets/images/home/launch_image_2.jpg',
        title: '独享私人空间',
        desc: '独享你的私人空间，专享你的甜蜜时光，保护你的私密活动，保护你的秘密家园。',
      ),
      _SwiperItem(
        background: 'assets/images/home/launch_image_3.jpg',
        title: '志同道合的人',
        desc: '和像你一样的人约会。',
      ),
    ];
  }

  final indexRx = 0.obs;

  @override
  Widget build(BuildContext context) {
    return SystemUI.light(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            buildSwiper(),
            buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget buildSwiper() {
    return Swiper(
        onIndexChanged: indexRx.call,
        itemBuilder: (_, index) {
          final item = _items[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: AppImage.asset(item.background, fit: BoxFit.cover),
              ),
              Column(
                children: [
                  Padding(
                    padding: FEdgeInsets(top: Get.height - 340.rpx - Get.padding.bottom),
                    child: Text(
                      item.title,
                      style: AppTextStyle.fs24b.copyWith(
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: FEdgeInsets(horizontal: 34.rpx, top: 20.rpx),
                    child: Text(
                      item.desc,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.fs14m.copyWith(
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        itemCount: _items.length);
  }

  Widget buildSwiperIndicator() {
    return Obx(() {
      final currentIndex = indexRx();
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(_items.length, (index) {
          final isSelected = currentIndex == index;
          return Container(
            width: 10.rpx,
            height: 10.rpx,
            decoration: ShapeDecoration(
              shape: const CircleBorder(
                  side: BorderSide(width: 1, color: Colors.white)),
              color: isSelected ? Colors.white : null,
            ),
          );
        }).separated(Spacing.w(10)).toList(),
      );
    });
  }

  Widget buildBottomPanel() {
    return Positioned.fill(
      top: null,
      child: Column(
        children: [
          buildSwiperIndicator(),
          Container(
            height: 50.rpx,
            margin: FEdgeInsets(top: 32.rpx),
            child: CommonGradientButton(
              onTap: onStartNow,
              width: 327.rpx,
              height: 50.rpx,
              text: '马上开始',
              textStyle: AppTextStyle.fs16b.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Button(
            width: 88.rpx,
            height: 50.rpx,
            margin: FEdgeInsets(top: 32.rpx, bottom: 54.rpx + Get.padding.bottom),
            backgroundColor: Colors.transparent,
            onPressed: onStartNow,
            child: Text(
              '登录账户',
              style: AppTextStyle.fs14m.copyWith(
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onStartNow(){
    Global.agreePrivacyPolicy().whenComplete(Get.navigateToHomeOrLogin);
  }
}

class _SwiperItem {
  final String background;
  final String title;
  final String desc;

  _SwiperItem({
    required this.background,
    required this.title,
    required this.desc,
  });
}
