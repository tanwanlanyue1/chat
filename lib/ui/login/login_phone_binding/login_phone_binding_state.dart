import 'package:get/get.dart';

class LoginPhoneBindingState {

  RxBool isClickBinding = false.obs; // 是否允许点击绑定按钮
  final smsButtonText = "获取验证码".obs; // 获取验证码按钮文本
  final isCountingDown = false.obs; // 是否正在倒计时
  LoginPhoneBindingState() {
    ///Initialize variables
  }
}
