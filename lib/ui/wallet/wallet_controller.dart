import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wallet/enum/wallet_enum.dart';

import 'wallet_state.dart';

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final WalletState state = WalletState();
  WalletController({
     this.moneyValue,
     this.tabIndex,
  });
   double? moneyValue;
   int? tabIndex;

  late final tabController = TabController(
    length: WalletOperationType.values.length,
    vsync: this,
    animationDuration: Duration.zero,
    initialIndex: WalletOperationType.record.index,
  );

  @override
  void onInit() {
    super.onInit();
    //刷新余额
    SS.login.fetchMyInfo();
    if (tabIndex != null) {
      tabController.animateTo(tabIndex ??2);
    }
  }

  void onTapOrder() {
    Get.toNamed(AppRoutes.walletOrderListPage);
  }

  void onTapOperation(WalletOperationType type) {
    tabController.index = type.index;
  }

  ///充值
  void onTapRecharge() {}

  void onTapSubmitOtherTopUp() {}

  void onTapSubmitTransfer() {}

  void onTapReload() {}
}
