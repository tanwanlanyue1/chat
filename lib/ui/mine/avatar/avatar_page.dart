import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'avatar_controller.dart';

/// 个人头像
/// 📢：外部使用要先 Get.put(AvatarController())
class AvatarPage extends StatelessWidget {
  AvatarPage({super.key});

  final controller = Get.put(AvatarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.userAvatarTitle),
        actions: [
          GestureDetector(
            onTap: controller.onTapMore,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              padding: EdgeInsets.symmetric(horizontal: 10.rpx),
              child: AppImage.asset(
                "assets/images/mine/more.png",
                size: 24.rpx,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 100.rpx),
          child: AppImage.network(
            controller.avatar.value,
            length: Get.width - 32.rpx,
          ),
        );
      }),
    );
  }
}
