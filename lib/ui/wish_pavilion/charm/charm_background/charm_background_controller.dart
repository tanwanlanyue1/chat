import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/image_gallery_utils.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_purchase_tip_dialog.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_top_up_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'charm_background_state.dart';

class CharmBackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CharmBackgroundState state = CharmBackgroundState();

  final loginService = SS.login;

  late TabController tabController;

  final pagingController = DefaultPagingController<CharmRes>(
    refreshController: RefreshController(),
  );

  void onTapMe() {
    Get.toNamed(AppRoutes.myCharmPage);
  }

  void onPaymentOrSafe(CharmRes model) {
    loginService.requiredAuthorized(() async {
      if (model.isHave == 1) {
        ImageGalleryUtils.saveNetworkImage(model.perfectImageUrl);
        return;
      }

      if ((loginService.levelMoneyInfo?.money ?? 0) < model.goldNum) {
        Get.dialog(const CharmTopUpDialog());
        return;
      }

      Get.dialog(CharmPurchaseTipDialog(
        name: model.name,
        goldNum: model.goldNum,
        onConfirm: () async {
          Loading.show();
          final res = await CharmApi.inviteOrPayment(
            type: 1,
            giftId: model.id,
          );
          Loading.dismiss();
          if (!res.isSuccess) {
            res.showErrorMessage();
            return;
          }

          loginService.fetchLevelMoneyInfo();
          pagingController.refresh();
        },
      ));
    });
  }

  void _fetchPage(int page) async {
    final res = await CharmApi.getWallpaperList(
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
