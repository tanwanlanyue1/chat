import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'login_state.dart';

class LoginController extends GetxController with GetAutoDisposeMixin {
  final LoginState state = LoginState();

  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // 协议点击手势
  TapGestureRecognizer protocolProtocolRecognizer = TapGestureRecognizer();
  TapGestureRecognizer privacyProtocolRecognizer = TapGestureRecognizer();

  Timer? _timer;
  var _remainingSeconds = 60;

  void changeVisible() {
    state.isVisible.value = !state.isVisible.value;
  }

  void onTapToProtocol() {
    WebPage.go(url: AppConfig.urlUserService, title: '用户服务协议');
  }

  void onTapToPrivacy() {
    WebPage.go(url: AppConfig.urlPrivacyPolicy, title: '隐私政策');
  }

  void changeSelectPrivacy() {
    state.isSelectPrivacy.value = !state.isSelectPrivacy.value;
  }

  void onTapToForgotPage() async {
    Get.toNamed(AppRoutes.loginForgotPage);
  }

  void onTapToRegisterPage() async {
    Get.toNamed(AppRoutes.loginRegisterPage);
  }

  void onTapToPasswordLoginPage() {
    Get.toNamed(AppRoutes.loginPage,
        arguments: {"type": 1}, preventDuplicates: false);
  }

  void onFetchSms() async {
    FocusScope.of(Get.context!).unfocus();

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

  void onTapLogin() async {
    FocusScope.of(Get.context!).unfocus();

    Loading.show();
    Result<void, String> result = await SS.login.loginByPassword(
      account: accountController.text,
      password: passwordController.text,
    );
    Loading.dismiss();
    result.when(success: (_) {
      Get.navigateToHomeOrLogin();
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
        state.smsButtonText.value = "${_remainingSeconds}s";
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

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();

    protocolProtocolRecognizer.dispose();
    privacyProtocolRecognizer.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
