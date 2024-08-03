import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/ui/mine/widgets/beautiful_status_switch.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/ui/home/home_controller.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'mine_state.dart';
import 'widgets/activation_progression.dart';
import 'widgets/security_deposit_dialog.dart';
import 'widgets/sign_out_dialog.dart';

class MineController extends GetxController {
  final MineState state = MineState();

  final refreshController = RefreshController();

  late final loginService = SS.login;

  @override
  void onInit() {
    super.onInit();
  }

  void onRefresh() {
    if (loginService.isLogin) {
      loginService
          .fetchMyInfo()
          .whenComplete(() => refreshController.refreshCompleted());
    } else {
      refreshController.refreshCompleted();
    }
  }

  void onTapLogin() {
    Get.toNamed(AppRoutes.loginPage);
  }

  void onTapGoldDetails() {
    Get.toNamed(AppRoutes.mineGoldDetail);
  }

  void onTapPurchase() {
    Get.toNamed(AppRoutes.minePurchase);
  }

  ///切换佳丽状态
  void onTapBeautifulStatus(UserStatus status) async{
    if(status == UserStatus.online) {
      final result = await SecurityDepositDialog.show();
      if (!result) {
        return;
      }
    }
    Loading.show();
    final response = await UserApi.updateState(status.value);
    Loading.dismiss();
    if(response.isSuccess){
      SS.login.setInfo((val) {
        val?.state = status;
      });
    }else{
      response.showErrorMessage();
    }
  }

  void onTapSignOut() async {
    final result = await SignOutDialog.show();
    if(result == true){
      Loading.show();
      final res = await SS.login.signOut();
      Loading.dismiss();
      res.when(
          success: (_) {},
          failure: (errorMessage) {
            Loading.showToast(errorMessage);
          });
      Get.offAllNamed(AppRoutes.loginPage);
    }
  }
}
