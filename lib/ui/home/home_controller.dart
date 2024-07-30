import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/mine_setting/app_update/app_update_manager.dart';
import 'package:guanjia/ui/mine/mine_setting/push_setting/notification_permission_util.dart';
import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  late PageController pageController =
      PageController(initialPage: state.initPage.value);
  //分页控制器
  final pagingController = DefaultPagingController<dynamic>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    final loginService = SS.login;
    if (loginService.isLogin) {
      SS.login.fetchMyInfo();
      SS.login.fetchLevelMoneyInfo();
      SS.login.fetchBindingInfo();
    }
    if(Platform.isAndroid){
      NotificationPermissionUtil.instance.initialize();
    }

    // pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if(Platform.isAndroid){
      AppUpdateManager.instance.checkAppUpdate();
    }
  }

  set setInitPage(int index) {
    state.initPage.value = index;
    pageController.jumpToPage(index);
  }

  void updateInfoList() {
    final loginService = SS.login;
    if (!loginService.isLogin) return;
    loginService.fetchLevelMoneyInfo();
    loginService.fetchMyInfo();
  }

}
