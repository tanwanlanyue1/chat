import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/mine_setting/app_update/app_update_manager.dart';
import 'package:guanjia/ui/mine/mine_setting/push_setting/notification_permission_util.dart';
import 'bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  late PageController pageController =
      PageController(initialPage: state.initPage.value);
  //分页控制器
  final pagingController = DefaultPagingController<HistoryModel>(
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

    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if(Platform.isAndroid){
      AppUpdateManager.instance.checkAppUpdate();
    }
  }

  /// 获取列表数据
  /// page: 第几页
  ///查询用户解惑玩法历史
  void fetchPage(int page) async {
    final response = await DisambiguationApi.getProblemList(page: page);
    if (response.isSuccess) {
      if (page == 1) {
        pagingController.itemList?.clear();
      }
      pagingController.setPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //删除数据
  Future<void> removeData(HistoryModel item) async {
    List<HistoryModel> data = List.of(pagingController.itemList!);
    final response = await DisambiguationApi.getDelete(id: item.id!);
    if (response.isSuccess) {
      data.remove(item);
      pagingController.itemList = data;
    } else {
      response.showErrorMessage();
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

  ///查询历史疑惑-详情
  ///	玩法类型（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
  Future<void> getLogDetail({required HistoryModel item}) async {
    Map history = {
      "parameter": item.parameter,
      "answer": item.result,
      "head": true,
    };
    BottomSheetChatPage.show(
      type: item.type!,
      item: history,
    );
  }
}
