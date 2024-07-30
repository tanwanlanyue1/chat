import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
