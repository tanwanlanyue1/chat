import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'forgot_state.dart';

class ForgotController extends GetxController {
  final ForgotState state = ForgotState();

  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();

    super.onClose();
  }

  void onTapToNext() {
    Get.toNamed(AppRoutes.loginForgotPage,
        arguments: {"isNext": true}, preventDuplicates: false);
  }
}
