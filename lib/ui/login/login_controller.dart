import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/ui/login/widgets/privacy_policy_dialog.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'login_state.dart';

class LoginController extends GetxController with GetAutoDisposeMixin {
  final LoginState state = LoginState();

  // 验证码
  TextEditingController accountController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();

  // 密码
  TextEditingController passwordAccountController = TextEditingController();
  TextEditingController passwordCodeController = TextEditingController();

  // 注册专用
  TextEditingController registerAccountController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerConfirmPasswordController =
      TextEditingController();

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
    final res = await SS.login.fetchSms(phone: accountController.text);
    Loading.dismiss();
    res.when(success: (_) {
      Loading.showToast("短信发送成功");
      _startTimer();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  void onLogin(int type) async {
    FocusScope.of(Get.context!).unfocus();

    if (!(await _verifyPrivacy())) return;

    if (type == 2) {
      if (registerPasswordController.text !=
          registerConfirmPasswordController.text) {
        Loading.showToast("两次输入的密码不一致");
        return;
      }
    }

    Loading.show();

    Result<void, String> result;
    if (type == 0) {
      result = await SS.login.loginByVerifyCode(
        phone: accountController.text,
        verifyCode: smsCodeController.text,
      );
    } else if (type == 1) {
      result = await SS.login.loginByPassword(
        phone: passwordAccountController.text,
        password: passwordCodeController.text,
      );
    } else {
      result = await SS.login.loginByRegister(
        account: registerAccountController.text,
        password: registerPasswordController.text,
      );
    }
    Loading.dismiss();
    result.when(success: (_) {
      Get.backToRoot();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  bool _isValidAccountText(String text) {
    final onlyAlphabeticRegex = RegExp(r'^[a-zA-Z]+$');
    final onlyNumericRegex = RegExp(r'^[0-9]+$');
    final onlySpecialCharRegex = RegExp(r'^[^a-zA-Z0-9]+$');

    return !(onlyAlphabeticRegex.hasMatch(text) ||
        onlyNumericRegex.hasMatch(text) ||
        onlySpecialCharRegex.hasMatch(text));
  }

  bool _isValidPasswordText(String text) {
    final hasAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(text);
    final hasNumeric = RegExp(r'[0-9]').hasMatch(text);
    final onlyAlphaNumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);

    return hasAlphabetic && hasNumeric && onlyAlphaNumeric;
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
    state.smsButtonText.value = "获取验证码";
  }

  // 校验是否点击下方协议
  Future<bool> _verifyPrivacy() async {
    if (!state.isSelectPrivacy.value) {
      final res = await PrivacyPolicyDialog.show();
      if (!(res ?? false)) return false;

      state.isSelectPrivacy.value = true;
      return true;
    }
    return true;
  }

  void _smsTextChanged() {
    state.isSmsReady.value =
        accountController.text.isNotEmpty && smsCodeController.text.isNotEmpty;
  }

  void _passwordTextChanged() {
    state.isPasswordReady.value = passwordAccountController.text.isNotEmpty &&
        passwordCodeController.text.isNotEmpty;
  }

  void _registerTextChanged() {
    state.isRegisterReady.value = registerAccountController.text.isNotEmpty &&
        registerPasswordController.text.isNotEmpty &&
        registerConfirmPasswordController.text.isNotEmpty;

    state.isRegisterAccountReady.value =
        registerAccountController.text.isNotEmpty;
  }

  @override
  void onInit() async {
    accountController.addListener(_smsTextChanged);
    smsCodeController.addListener(_smsTextChanged);

    passwordAccountController.addListener(_passwordTextChanged);
    passwordCodeController.addListener(_passwordTextChanged);

    registerAccountController.addListener(_registerTextChanged);
    registerPasswordController.addListener(_registerTextChanged);
    registerConfirmPasswordController.addListener(_registerTextChanged);

    super.onInit();
  }

  @override
  void onClose() {
    accountController.removeListener(_smsTextChanged);
    smsCodeController.removeListener(_smsTextChanged);

    passwordAccountController.removeListener(_passwordTextChanged);
    passwordCodeController.removeListener(_passwordTextChanged);

    registerAccountController.removeListener(_registerTextChanged);
    registerPasswordController.removeListener(_registerTextChanged);
    registerConfirmPasswordController.removeListener(_registerTextChanged);

    accountController.dispose();
    smsCodeController.dispose();

    passwordAccountController.dispose();
    passwordCodeController.dispose();

    registerAccountController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();

    protocolProtocolRecognizer.dispose();
    privacyProtocolRecognizer.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
