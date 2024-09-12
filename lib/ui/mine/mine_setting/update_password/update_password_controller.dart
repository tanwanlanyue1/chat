import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/firebase_util.dart';
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
      state.type = true;
      state.isPhone.value = !type;
      state.phone = text!;
    }
  }

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  /// 获取邮箱验证码
  Future<bool> fetchEmailVerificationCode() async {
    if(!state.isPhone.value && !GetUtils.isEmail(state.phone)){
      Loading.showToast('邮箱格式错误');
      return false;
    }else{
      Loading.show();
      final res = await state.loginService.fetchSms(
          type: 2,
          phone: state.phone
      );
      Loading.dismiss();

      return res.when(success: (_) {
        return true;
      }, failure: (errorMessage) {
        Loading.showToast(errorMessage);
        return false;
      });
    }
  }


  /// 获取短信验证码
  Future<bool> fetchSmsVerificationCode() async {
    if(state.phone.isEmpty){
      Loading.showToast('请输入手机号码');
      return false;
    }
    Loading.show();
    final verificationId = await FirebaseUtil().sendSmsCode('${state.countryCode}${state.phone}');
    Loading.dismiss();
    if(verificationId != null){
      state.verificationId = verificationId;
      return true;
    }else{
      Loading.showToast('获取验证码失败');
      return false;
    }
  }

  /// 提交修改-登录密码
  void submit() async {
    final isPhone = state.isPhone();
    final phoneOrEmail = state.phone;
    final verificationCode = verificationInputController.text.trim();
    final newPassword = newPasswordInputController.text;
    final confirmPassword = confirmPasswordInputController.text;

    Loading.show();
    String? idToken;
    if(isPhone){
      idToken = await FirebaseUtil().verifySmsCode(state.verificationId, verificationCode);
      if(idToken == null){
        Loading.dismiss();
        Loading.showToast('验证码错误，请重新输入');
        return;
      }
    }

    Loading.show();
    final res = await state.loginService.forgotOrResetPassword(
      type: isPhone ? 1 : 2,
      phone: isPhone ? phoneOrEmail : null,
      email: isPhone ? null : phoneOrEmail,
      verifyCode: isPhone ? null : verificationCode,
      idToken: isPhone ? idToken : null,
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
    final isPhone = state.isPhone();
    final phoneOrEmail = state.phone;
    final verificationCode = verificationInputController.text.trim();

    Loading.show();
    String? idToken;
    if(isPhone){
      idToken = await FirebaseUtil().verifySmsCode(state.verificationId, verificationCode);
      if(idToken == null){
        Loading.dismiss();
        Loading.showToast('验证码错误，请重新输入');
        return;
      }
    }

    final response = await UserApi.updatePayPwd(
      type: isPhone ? 1 : 2,
      phone: isPhone ? phoneOrEmail : null,
      email: isPhone ? null : phoneOrEmail,
      verifyCode: isPhone ? null : verificationCode,
      idToken: isPhone ? idToken : null,
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
    final info = state.loginService.info;
    if((info?.email?.isNotEmpty ?? false) && (info?.phone?.isNotEmpty ?? false)){
      state.isPhone.value = !state.isPhone.value;
      if(state.isPhone()){
        state.phone = info?.phone ?? '';
      }else{
        state.phone = info?.email ?? '';
      }
      phoneNumberInputController.text = maskSubstring(state.phone);
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
      if (input.length < 4) return input;
      return '${input.substring(0, 4)}****';
    } else {
      String prefix = input.substring(0, 4);
      String suffix = input.substring(8);
      return '$prefix****$suffix';
    }
  }
}
