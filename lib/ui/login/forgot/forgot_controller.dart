import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/common_utils.dart';

import 'forgot_state.dart';

class ForgotController extends GetxController {
  final ForgotState state = ForgotState();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();

    super.onClose();
  }

  void onTapToNext() {
    // Get.toNamed(AppRoutes.loginForgotPage,
    //     arguments: {"isNext": true}, preventDuplicates: false);

    CommonUtils.hideSoftKeyboard();

    var text = state.isEmailValid.isTrue ? emailController.text : state.phone;
    if (text.isEmpty) return;

    Get.toNamed(AppRoutes.updatePasswordPage, arguments: {
      "type": state.isEmailValid.value,
      "countryCode": state.countryCode,
      "text": text,
    });
  }
}
