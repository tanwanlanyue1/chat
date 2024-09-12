import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

class UpdatePasswordState {
  final loginService = SS.login;

  final isVisible = false.obs;

  //是否手机号验证
  final isPhone = true.obs;

  //修改登录/修改支付
  final isLogin = true.obs;

  final obscure = true.obs;

  //登陆忘记密码进入
  bool type = false;

  //
  String phone = "";

  String verificationId = "";
  String countryCode = "";
}
