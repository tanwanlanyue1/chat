import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'disambiguation_state.dart';

class DisambiguationController extends GetxController
    with GetSingleTickerProviderStateMixin{
  final DisambiguationState state = DisambiguationState();
  late TabController tabController;

  precacheNetwork(String url,{bool back = false}){
    precacheImage(NetworkImage(url), Get.context!,size: back ?
    Size(Get.width, 200.rpx):Size(58.rpx, 58.rpx),);
  }

  @override
  void onInit() {
    // precacheImage(
    //   const AppAssetImage('assets/images/disambiguation/head_background.png'),
    //   Get.context!,
    //   size: Size(Get.width, 200.rpx),
    // );
    final list = SS.appConfig.configRx()?.home ?? [];
    if(list.isEmpty){
      once<AppConfigModel?>(SS.appConfig.configRx, (appConfig) {
        _initTabController(appConfig?.home ?? []);
      });
    }else{
      _initTabController(list);
    }
    super.onInit();
  }

  void _initTabController(List<Home> home){
    state.appHome.value = home;
    tabController = TabController(
      length: state.appHome.length,
      vsync: this,
      initialIndex: state.divinationIndex.value,
      animationDuration: const Duration(milliseconds: 300),
    );
    for (var element in state.appHome) {
      precacheNetwork(element.background ?? '',back: true);
      precacheNetwork(element.selectIcon ?? '');
      precacheNetwork(element.icon ?? '');
    }
  }
}
