import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';

import 'payment_password_state.dart';

class PaymentPasswordController extends GetxController {
  final PaymentPasswordState state = PaymentPasswordState();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // final phoneString = state.loginService.isLogin
    //     ? _maskPhoneNumber(state.loginService.info?.phone ?? "")
    //     : "";

    newPasswordInputController.addListener(_checkFields);
    confirmPasswordInputController.addListener(_checkFields);
  }

  /// 提交修改
  void submit() async {
    // final phone = state.loginService.isLogin
    //     ? state.loginService.info?.phone ?? ""
    //     : phoneNumberInputController.text;
    // final verifyCode = verificationInputController.text;
    // final newPassword = newPasswordInputController.text;
    // final confirmPassword = confirmPasswordInputController.text;
    //
    // Loading.show();
    // final res = await state.loginService.forgotOrResetPassword(
    //   phone: phone,
    //   verifyCode: verifyCode,
    //   password: newPassword,
    //   confirmPassword: confirmPassword,
    // );
    // Loading.dismiss();
    //
    // res.when(success: (_) {
    //   Loading.showToast("修改成功");
    //   Get.back();
    // }, failure: (errorMessage) {
    //   Loading.showToast(errorMessage);
    // });
  }

  void _checkFields() {
    state.isVisible.value = newPasswordInputController.text.isNotEmpty &&
        confirmPasswordInputController.text.isNotEmpty;
  }


  @override
  void onClose() {
    newPasswordInputController.removeListener(_checkFields);
    confirmPasswordInputController.removeListener(_checkFields);

    newPasswordInputController.dispose();
    confirmPasswordInputController.dispose();

    super.onClose();
  }
}
