import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/open_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/firebase_util.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/recaptcha_dialog.dart';

import 'binding_state.dart';

class BindingController extends GetxController {
  BindingController({
    int? currentIndex,
  }){// //0:手机，1:邮箱
    state.currentIndex = currentIndex ?? -1;
  }
  final BindingState state = BindingState();

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();

  final loginService = SS.login;

  /// 获取邮箱验证码
  Future<bool> fetchEmailVerificationCode() async {
    final email = phoneNumberInputController.text.trim();
    if(!GetUtils.isEmail(email)){
      Loading.showToast('邮箱格式错误');
      return false;
    }

    final res = await loginService.fetchEmailVerificationCode(email);
    return res.when(success: (_) {
      return true;
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
      return false;
    });
  }

  /// 获取短信验证码
  Future<bool> fetchSmsVerificationCode() async {
    final phone = phoneNumberInputController.text.trim();
    if(phone.isEmpty){
      Loading.showToast('请输入手机号码');
      return false;
    }

    final verificationId = await FirebaseUtil().sendSmsCode('${state.countryCode}$phone');
    state.verificationId = verificationId ?? '';
    return state.verificationId.isNotEmpty;
  }

  ///绑定
  void submit() async {
    final isPhone = state.isPhone();
    final phoneOrEmail = phoneNumberInputController.text.trim();
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
    final response = await UserApi.userBind(
      type: isPhone ? 1 : 2,
      email: isPhone ? null : phoneOrEmail,
      phone: isPhone ? state.countryCode + phoneOrEmail : null,
      verifyCode: isPhone ? null : verificationCode,
      idToken: idToken,
    );
    Loading.dismiss();
    if(response.isSuccess){
      Loading.showToast(S.current.bindingSuccessful);
      loginService.fetchMyInfo();
      Get.back();
    }else{
      response.showErrorMessage();
    }
  }

  @override
  void onInit() {
    super.onInit();

    phoneNumberInputController.addListener(_checkFields);
    verificationInputController.addListener(_checkFields);
    state.isPhone.value = (state.currentIndex == 1 ? false : true);
  }

  @override
  void onClose() {
    phoneNumberInputController.dispose();
    verificationInputController.dispose();

    super.onClose();
  }

  void _checkFields() {
    state.isVisible.value = phoneNumberInputController.text.isNotEmpty &&
        verificationInputController.text.isNotEmpty;
  }
}
