import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/widgets/loading.dart';
import 'update_password_state.dart';

class UpdatePasswordController extends GetxController with GetAutoDisposeMixin {
  final state = UpdatePasswordState();

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  /// 获取短信验证码
  Future<bool> fetchSms() async {
    final phone = state.loginService.isLogin
        ? state.loginService.bindingInfo?.phone ?? ""
        : phoneNumberInputController.text;

    if (phone.length != 11) {
      Loading.showToast('请输入手机号码');
      return false;
    }

    Loading.show();
    final res = await state.loginService.fetchSms(phone: phone);
    Loading.dismiss();

    return res.when(success: (_) {
      return true;
    }, failure: (errorMessage) {
      return false;
    });
  }

  /// 提交修改
  void submit() async {
    final phone = state.loginService.isLogin
        ? state.loginService.bindingInfo?.phone ?? ""
        : phoneNumberInputController.text;
    final verifyCode = verificationInputController.text;
    final newPassword = newPasswordInputController.text;
    final confirmPassword = confirmPasswordInputController.text;

    Loading.show();
    final res = await state.loginService.forgotOrResetPassword(
      phone: phone,
      verifyCode: verifyCode,
      password: newPassword,
      confirmPassword: confirmPassword,
    );
    Loading.dismiss();

    res.when(success: (_) {
      Loading.showToast("修改成功");
      Get.back();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  @override
  void onInit() {
    super.onInit();

    // 已登录需要显示带星号的电话号码
    final phoneString = state.loginService.isLogin
        ? _maskPhoneNumber(state.loginService.bindingInfo?.phone ?? "")
        : "";
    phoneNumberInputController.text = phoneString;

    phoneNumberInputController.addListener(_checkFields);
    verificationInputController.addListener(_checkFields);
    newPasswordInputController.addListener(_checkFields);
    confirmPasswordInputController.addListener(_checkFields);
  }

  @override
  void onClose() {
    phoneNumberInputController.removeListener(_checkFields);
    verificationInputController.removeListener(_checkFields);
    newPasswordInputController.removeListener(_checkFields);
    confirmPasswordInputController.removeListener(_checkFields);

    phoneNumberInputController.dispose();
    verificationInputController.dispose();
    newPasswordInputController.dispose();
    confirmPasswordInputController.dispose();

    super.onClose();
  }

  void _checkFields() {
    state.isVisible.value = phoneNumberInputController.text.isNotEmpty &&
        verificationInputController.text.isNotEmpty &&
        newPasswordInputController.text.isNotEmpty &&
        confirmPasswordInputController.text.isNotEmpty;
  }

  String _maskPhoneNumber(String phoneNumber) {
    // 正则表达式匹配手机号码中间四位
    RegExp regExp = RegExp(r'(\d{3})\d{4}(\d{4})');
    // 使用replaceAllMapped方法进行替换
    return phoneNumber.replaceAllMapped(regExp, (Match match) {
      return '${match.group(1)}****${match.group(2)}';
    });
  }
}
