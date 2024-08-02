import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/web_page.dart';

import 'account_safety_state.dart';

class AccountSafetyController extends GetxController {
  final AccountSafetyState state = AccountSafetyState();

  final loginService = SS.login;

  void onTapCopyAccountId() async {
    "${loginService.info?.chatNo}".copy();
  }

  void onTapBinding() {
    Get.toNamed(AppRoutes.bindingPage);
  }

  void onTapUpdatePassword() {
    final phone = loginService.info?.phone ?? "";
    final isBinding = phone.isNotEmpty;

    if (isBinding) {
      Get.toNamed(AppRoutes.updatePasswordPage);
      return;
    }

    Loading.showToast("请先绑定手机");
    Get.toNamed(AppRoutes.bindingPage);
  }

  //注销
  void onTapSignOut() {
    final phone = loginService.info?.phone ?? "";
    final isBinding = phone.isNotEmpty;

    if (!isBinding) {
      Loading.showToast("请先绑定手机");
      Get.toNamed(AppRoutes.bindingPage);
      return;
    }

    WebPage.go(
      title: '账户注销',
      url:
          '${state.cancelAccountLink.value}?t=${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void onInit() {
    state.accountId.value = loginService.info?.chatNo.toString() ?? "";
    state.cancelAccountLink.value =
        SS.appConfig.configRx()?.cancelAccountLink ??
            AppConfig.urlAccountCancellation;
    super.onInit();
  }
}
