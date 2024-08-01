import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

class LoginState {
  final isVisible = false.obs; // 输入密码是否可见
  final isSelectPrivacy = false.obs; // 用户协议是否选中

  final isSmsReady = false.obs; // 验证码登录是否点击
  final isPasswordReady = false.obs; // 密码登录是否点击
  final isRegisterReady = false.obs; // 注册是否点击
  final isRegisterAccountReady = false.obs; // 注册用户账号是否未输入

  final smsButtonText = S.current.getCode.obs; // 获取验证码按钮文本
  final isCountingDown = false.obs; // 是否正在倒计时

  final hasOneKeyLogin = true.obs; //是否支持本机号码一键登录
  final hasWXLogin = false.obs; //是否支持wx一键登录
}
