import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'update_password_state.dart';

class UpdatePasswordController extends GetxController with GetAutoDisposeMixin {
  final state = UpdatePasswordState();
  UpdatePasswordController({
    bool? login,
    bool? type,
    String? text,
  }){// true：修改登录密码，false：修改支付密码，
    state.isLogin.value = login ?? true;
    if(type != null){
      state.isPhone.value = !type;
      state.phone = text!;
    }
  }

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  /// 获取短信验证码
  Future<bool> fetchSms() async {

    Loading.show();
    final res = await state.loginService.fetchSms(
        type: state.isPhone.value ? 1 : 2,
        phone: state.phone
    );
    Loading.dismiss();

    return res.when(success: (_) {
      return true;
    }, failure: (errorMessage) {
      return false;
    });
  }

  /// 提交修改-登录密码
  void submit() async {
    final verifyCode = verificationInputController.text;
    final newPassword = newPasswordInputController.text;
    final confirmPassword = confirmPasswordInputController.text;

    Loading.show();
    final res = await state.loginService.forgotOrResetPassword(
      type: state.isPhone.value ? 1 : 2,
      phone: state.phone,
      email: state.phone,
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

  /// 提交修改-支付密码
  void submitPayment() async {
    Loading.show();
    final response = await UserApi.updatePayPwd(
      type: state.isPhone.value ? 1 : 2,
      phone: state.phone,
      email: state.phone,
      verifyCode: verificationInputController.text,
      password: newPasswordInputController.text,
      confirmPassword: confirmPasswordInputController.text,
    );
    Loading.dismiss();
    if(response.isSuccess){
      Loading.showToast(S.current.setSuccessfully);
      Get.back();
    }else{
      response.showErrorMessage();
    }
    SS.login.fetchMyInfo();
  }

  void setLoginService(){
    if(state.loginService.info != null){
      if(state.loginService.info?.phone?.isNotEmpty ?? false){
        state.isPhone.value = true;
        state.phone = state.loginService.info?.phone ?? '';
      }else{
        state.isPhone.value = false;
        state.phone = state.loginService.info?.email ?? '';
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    setLoginService();
    // 已登录需要显示带星号的电话号码 phone
    final phoneString = maskSubstring(state.phone);
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
    if((state.loginService.info?.email?.isNotEmpty ?? false) && (state.loginService.info?.phone?.isNotEmpty ?? false)){
      state.isPhone.value = !state.isPhone.value;
    }else{
      if(state.isPhone.value){
        Loading.showToast("${S.current.unboundMailbox}，${S.current.pleaseBindFirst}");
      }else{
        Loading.showToast("${S.current.unboundPhone}，${S.current.pleaseBindFirst}");
      }
    }
  }

  //设置支付密码 affirm确认
  void setPayPassword({bool affirm = false}) async{
    final result = await PaymentPasswordKeyboard.show(
        titleStr: S.current.pleaseEnterYourPaymentPassword
    );
    if(result != null){
      if(affirm){
        if(result == newPasswordInputController.text){
          confirmPasswordInputController.text = result;
        }else{
          Loading.showToast(S.current.enteredPasswordsDiffer);
        }
      }else{
        newPasswordInputController.text = result;
      }
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
