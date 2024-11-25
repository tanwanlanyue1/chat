import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/notification/notification_manager.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/ui/mine/mine_setting/app_update/app_update_manager.dart';
import 'package:guanjia/ui/mine/mine_setting/push_setting/notification_permission_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'home_state.dart';

class HomeController extends GetxController with GetAutoDisposeMixin, GetSingleTickerProviderStateMixin {
  final HomeState state = HomeState();
  late PageController pageController =
      PageController(initialPage: state.currentPageRx.value);

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
    }
    if (Platform.isAndroid) {
      NotificationPermissionUtil.instance.initialize();
    }
    SS.location.reportPosition(silent: false);

    //监听消息未读数
    final messageUnread = ZIMKit.instance.getTotalUnreadMessageCount();
    _refreshMessageUnread(messageUnread);
    messageUnread.addListener(() => _refreshMessageUnread(messageUnread));
    autoDisposeWorker(
      ever(SS.inAppMessage.latestSysNoticeRx,
          (data) => _refreshMessageUnread(messageUnread)),
    );

    autoDisposeWorker(ever(Global().appStateRx, (state) {
      if (state == AppLifecycleState.resumed) {
        NotificationManager().jumpWithAppLaunch();
      }
    }));

    super.onInit();
  }

  void _refreshMessageUnread(ValueNotifier<int> messageUnread) {
    state.messageUnreadRx.value =
        messageUnread.value + (SS.inAppMessage.latestSysNoticeRx()?.total ?? 0);
  }

  @override
  void onReady() {
    super.onReady();
    if (Platform.isAndroid) {
      AppUpdateManager.instance.checkAppUpdate();
    }
    NotificationManager().jumpWithAppLaunch();
  }

  void setCurrentPage(int index) {
    if(index != state.currentPageRx()){
      final title = state.allBottomNavItems[index].title;
      if (title == S.current.mine) {
        EventBus().emit(kEventUserInfo);
      }
      state.currentPageRx.value = index;
      pageController.jumpToPage(index);
    }
  }

  void updateInfoList() {
    final loginService = SS.login;
    if (!loginService.isLogin) return;
    loginService.fetchMyInfo();
  }
}
