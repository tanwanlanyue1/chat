import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'update_password_state.dart';

class UpdatePasswordController extends GetxController with GetAutoDisposeMixin {
  final state = UpdatePasswordState();
  UpdatePasswordController({
    bool? login,
  }){// true：修改登录密码，false：修改支付密码，
    state.isLogin.value = login ?? true;
  }

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  /// 获取短信验证码
  Future<bool> fetchSms() async {
    final phone = state.loginService.isLogin
        ? state.loginService.info?.email ?? ""
        // ? state.loginService.info?.phone ?? ""
        : phoneNumberInputController.text;

    if (phone.length != 11) {
      Loading.showToast('请输入手机号码');
      return false;
    }

    Loading.show();
    final res = await state.loginService.fetchSms(type: 1,phone: phone);
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
        ? state.loginService.info?.phone ?? ""
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

    print("loginService==${state.loginService}");
    print("info==${jsonEncode(state.loginService.info)}");

    if(state.loginService.info?.phone?.isNotEmpty ?? false){
      state.isPhone.value = true;
    }else{
      state.isPhone.value = false;
    }
    // 已登录需要显示带星号的电话号码
    final phoneString = state.loginService.isLogin
        ? maskSubstring(state.isPhone.value ? (state.loginService.info?.phone ?? '') : (state.loginService.info?.email ?? ''))
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

  //判断是否绑定了其他验证方式
  void verificationMode(){
    if(state.isPhone.value && (state.loginService.info?.email?.isNotEmpty ?? false)){
      state.isPhone.value = !state.isPhone.value;
    }else{
      Loading.showToast("${S.current.unboundMailbox}，${S.current.pleaseBindFirst}");
    }
    if(!state.isPhone.value && (state.loginService.info?.phone?.isNotEmpty ?? false)){
      state.isPhone.value = !state.isPhone.value;
    }else{
      Loading.showToast("${S.current.unboundPhone}，${S.current.pleaseBindFirst}");
    }
  }

  //截取手机号/邮箱
  String maskSubstring(String input) {
    if (input.length < 8) {
      return '${input.substring(0, 4)}****';
    } else {
      String prefix = input.substring(0, 4);
      String suffix = input.substring(8);
      return '$prefix****$suffix';
    }
  }
}
