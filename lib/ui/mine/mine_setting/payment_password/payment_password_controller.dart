import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';

import 'payment_password_state.dart';

class PaymentPasswordController extends GetxController {
  final PaymentPasswordState state = PaymentPasswordState();
  final newPasswordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    newPasswordInputController.addListener(_checkFields);
    confirmPasswordInputController.addListener(_checkFields);
  }

  /// 提交修改
  void submit() async {
    Loading.show();
    final response = await UserApi.updatePayPwd(
      password: newPasswordInputController.text,
      confirmPassword: confirmPasswordInputController.text,
    );
    Loading.dismiss();
    if(response.isSuccess){
      Loading.showToast(S.current.setSuccessfully);
      SS.login.fetchMyInfo();
      Get.back();
    }else{
      response.showErrorMessage();
    }
  }

  void _checkFields() {
    state.isVisible.value = newPasswordInputController.text.isNotEmpty &&
        confirmPasswordInputController.text.isNotEmpty;
  }


  @override
  void onClose() {
    newPasswordInputController.removeListener(_checkFields);
    confirmPasswordInputController.removeListener(_checkFields);

    newPasswordInputController.dispose();
    confirmPasswordInputController.dispose();

    super.onClose();
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
}
