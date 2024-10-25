import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'discover_state.dart';

class DiscoverController extends GetxController with GetSingleTickerProviderStateMixin {
  final DiscoverState state = DiscoverState();
  late TabController tabController;

  //发布邀约
  void onTapInvitation() {
    Get.toNamed(AppRoutes.releaseInvitation);
  }

  @override
  void onInit() {
    precacheImage(
      const AppAssetImage('assets/images/plaza/friend_tab.png'),
      Get.context!,
      size: Size(17.rpx, 6.rpx),
    );
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
