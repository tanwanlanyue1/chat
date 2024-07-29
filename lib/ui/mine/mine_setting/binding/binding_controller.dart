import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import 'binding_state.dart';

class BindingController extends GetxController {
  final BindingState state = BindingState();

  final phoneNumberInputController = TextEditingController();
  final verificationInputController = TextEditingController();

  final loginService = SS.login;

  /// 获取短信验证码
  Future<bool> fetchSms() async {
    final phone = phoneNumberInputController.text;

    if (phone.length != 11) {
      Loading.showToast('请输入手机号码');
      return false;
    }

    Loading.show();
    final res = await loginService.fetchSms(phone: phone);
    Loading.dismiss();

    return res.when(success: (_) {
      return true;
    }, failure: (errorMessage) {
      return false;
    });
  }

  /// 提交绑定
  void submit() async {
    Loading.show();
    final res = await UserApi.binding(
      type: 3,
      state: 1,
      phone: phoneNumberInputController.text,
      verifyCode: verificationInputController.text,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    loginService.fetchMyInfo();
    loginService.fetchBindingInfo();

    Loading.showToast("绑定成功");
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();

    phoneNumberInputController.addListener(_checkFields);
    verificationInputController.addListener(_checkFields);
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
