import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'forgot_state.dart';

class ForgotController extends GetxController {
  final ForgotState state = ForgotState();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    codeController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();

    super.onClose();
  }

  void onTapToNext() {
    // Get.toNamed(AppRoutes.loginForgotPage,
    //     arguments: {"isNext": true}, preventDuplicates: false);

    Get.toNamed(AppRoutes.updatePasswordPage, arguments: {
      "isLogin": true,
      "type": state.isEmailValid.value,
      "text": state.isEmailValid.value
          ? emailController.text
          : phoneController.text,
    });
  }
}
