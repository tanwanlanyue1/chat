import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'plaza_state.dart';

class PlazaController extends GetxController with GetSingleTickerProviderStateMixin {
  final PlazaState state = PlazaState();
  late TabController tabController;


  @override
  void onInit() {
    precacheImage(
      const AppAssetImage('assets/images/plaza/recommend_back.png'),
      Get.context!,
      size: Size(Get.width, Get.height),
    );
    precacheImage(
      const AppAssetImage('assets/images/plaza/nearby_back.png'),
      Get.context!,
      size: Size(Get.width, Get.height),
    );
    precacheImage(
      const AppAssetImage('assets/images/plaza/community_back.png'),
      Get.context!,
      size: Size(Get.width, Get.height),
    );
    SS.location.reportPosition();
    tabController = TabController(length: state.tabBarList.length, vsync: this,initialIndex: state.tabIndex.value);
    super.onInit();
  }

}
