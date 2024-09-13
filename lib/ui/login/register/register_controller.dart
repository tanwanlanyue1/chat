import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/welcome/privacy_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'register_state.dart';

class RegisterController extends GetxController {
  final RegisterState state = RegisterState();
  static const _kPrivacyDialogVisible = 'PrivacyDialogVisible';
  final _localStorage = LocalStorage('RegisterController');

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    final isVisible =
        await _localStorage.getBool(_kPrivacyDialogVisible) ?? true;
    if (isVisible) {
      _localStorage.setBool(_kPrivacyDialogVisible, false);
      final result = await PrivacyDialog.show();
      if (result != true) {
        Future.delayed(const Duration(milliseconds: 200), Get.back);
      }
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.onClose();
  }

  void onTapRegister() async {
    FocusScope.of(Get.context!).unfocus();

    if (passwordController.text != passwordAgainController.text) {
      Loading.showToast(S.current.toastNeedSamePassword);
      return;
    }

    Result<void, String> result = await SS.login.loginByRegister(
      account: userNameController.text,
      password: passwordController.text,
    );
    result.when(success: (_) {
      Get.offAllNamed(AppRoutes.loginQuestionPage);
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }
}
