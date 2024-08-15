import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';

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

  /// 获取短信验证码
  Future<bool> fetchSms() async {
    final phone = phoneNumberInputController.text;

    Loading.show();
    final res = await loginService.fetchSms(
        type: state.isPhone.value ? 1 : 2,
        phone: phone);
    Loading.dismiss();

    return res.when(success: (_) {
      return true;
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
      return false;
    });
  }

  ///  绑定手机号/邮箱
  void submit() async {
    Loading.show();
    final response = await UserApi.userBind(
      type: state.isPhone.value ? 1 :2,
      phone: state.isPhone.value ? phoneNumberInputController.text : '',
      email: state.isPhone.value ? "" : phoneNumberInputController.text,
      verifyCode: verificationInputController.text,
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
