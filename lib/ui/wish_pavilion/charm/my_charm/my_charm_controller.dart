import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wish_pavilion/charm/charm_controller.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../../common/network/api/api.dart';
import 'my_charm_state.dart';

class MyCharmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MyCharmState state = MyCharmState();

  late TabController tabController;

  final loginService = SS.login;

  final pagingController = DefaultPagingController<CharmRecord>(
    refreshController: RefreshController(),
  );

  void onTapMe() {
    Get.toNamed(AppRoutes.myCharmPage);
  }

  void onTapPut(CharmRecord model) {
    final c = Get.find<CharmController>();
    c.state.charmRecord.value = model;
    Get.until((route) => Get.currentRoute == AppRoutes.charmPage);
  }

  void onGetMav(CharmRecord model) async {
    Loading.show();
    final res = await CharmApi.receiveMav(
      id: model.id,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    loginService.fetchLevelMoneyInfo();
    pagingController.refresh();
  }

  void _fetchPage(int page) async {
    final res = await CharmApi.getStatisticsList(
      type: state.tabIndex.value,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  void onTapTabIndex(int index) {
    state.tabIndex.value = index;
    pagingController.refresh();
  }

  @override
  void onInit() {
    tabController = TabController(
      length: state.tabTitles.length,
      vsync: this,
    );
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    pagingController.dispose();
    super.onClose();
  }
}
