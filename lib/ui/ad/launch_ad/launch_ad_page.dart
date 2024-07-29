import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/cache_manager_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'launch_ad_controller.dart';

///开屏广告
class LaunchAdPage extends StatelessWidget {
  LaunchAdPage({Key? key}) : super(key: key);

  final controller = Get.put(LaunchAdController());
  final state = Get.find<LaunchAdController>().state;

  @override
  Widget build(BuildContext context) {
    final adUrl = state.ad?.image ?? '';
    final adFile = state.adFile;
    if (adUrl.isEmpty) {
      return const SizedBox();
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if(adFile != null) _buildLocalImageAd(adFile),
          if(adFile == null) _buildNetworkImageAd(adUrl),
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildNetworkImageAd(String url) {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: url,
        cacheManager: DefaultCacheManagerX.instance,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  Widget _buildLocalImageAd(File file) {
    return Positioned.fill(
      child: Image.file(
        file,
        fit: BoxFit.cover,
      ),
    );
  }




  Widget _buildSkipButton() {
    return Positioned(
      top: Get.mediaQuery.padding.top + 20.rpx,
      right: 20.rpx,
      child: ObxValue((dataRx) {
        return _buildButton(
          onTap: controller.jumpHomePage,
          size: Size(88.rpx, 35.rpx),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 13.rpx,
          ),
          text: '${dataRx()} 秒后跳过',
        );
      }, state.secondsRx),
    );
  }

  Widget _buildButton({
    required String text,
    required Size size,
    required TextStyle textStyle,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
          shape: StadiumBorder(),
          color: Color(0x80000000),
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
