import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/widgets/loading.dart';

import 'register_state.dart';

class RegisterController extends GetxController {
  final RegisterState state = RegisterState();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void onTapRegister() async {
    FocusScope.of(Get.context!).unfocus();

    if (passwordController.text != passwordAgainController.text) {
      Loading.showToast("两次输入的密码不一致");
      return;
    }

    Loading.show();
    Result<void, String> result = await SS.login.loginByRegister(
      account: userNameController.text,
      password: passwordController.text,
      phone: phoneController.text,
      email: emailController.text,
    );
    Loading.dismiss();

    result.when(success: (_) {
      Get.toNamed(AppRoutes.loginQuestionPage);
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }
}
