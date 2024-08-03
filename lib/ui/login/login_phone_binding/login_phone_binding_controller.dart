import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';

import 'login_phone_binding_state.dart';

class LoginPhoneBindingController extends GetxController {
  final LoginPhoneBindingState state = LoginPhoneBindingState();

  TextEditingController accountController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();

  ///第三方授权code
  final String code;
  final String userIdentifier;
  final String identityToken;
  ///用户登录类型(1:密码登录,2:验证码登录,3:微信登录,4:一键登录,5:注册账号,6苹果登录)
  final int loginType;

  Timer? _timer;
  var _remainingSeconds = 60;

  LoginPhoneBindingController({
    required this.code,
    required this.userIdentifier,
    required this.identityToken,
    required this.loginType,
  });

  void onFetchSms() async {
    if (accountController.text.isEmpty) {
      Loading.showToast("请输入手机号码");
      return;
    }

    Loading.show();
    final res = await SS.login.fetchSms(type: 1,phone: accountController.text);
    Loading.dismiss();
    res.when(success: (_) {
      Loading.showToast("短信发送成功");
      _startTimer();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  void _startTimer() {
    _resetCountdown();

    state.isCountingDown.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        state.smsButtonText.value = _remainingSeconds.toString();
      } else {
        _resetCountdown();
      }
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    _timer = null;

    _remainingSeconds = 60;
    state.isCountingDown.value = false;
    state.smsButtonText.value = S.current.getCode;
  }

  void onBinding() async {
    if(![3,6].contains(loginType)){
      AppLogger.w('不支持的登录类型, loginType=$loginType');
      return;
    }

    Loading.show();
    Result<void, String> result;
    if(loginType == 3){
      result = await SS.login.loginByWeChat(
        phone: accountController.text.trim(),
        verifyCode: smsCodeController.text.trim(),
        code: code,
      );
    }else{
      result = await SS.login.loginByApple(
        phone: accountController.text.trim(),
        verifyCode: smsCodeController.text.trim(),
        identityToken: identityToken,
        userIdentifier: userIdentifier,
      );
    }
    Loading.dismiss();
    result.when(success: (_) {
      Get.navigateToHomeOrLogin();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  void _onTextChanged() {
    state.isClickBinding.value =
        !(accountController.text.isEmpty || smsCodeController.text.isEmpty);
  }

  @override
  void onInit() {
    accountController.addListener(_onTextChanged);
    smsCodeController.addListener(_onTextChanged);
    super.onInit();
  }

  @override
  void onClose() {
    accountController.dispose();
    smsCodeController.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
