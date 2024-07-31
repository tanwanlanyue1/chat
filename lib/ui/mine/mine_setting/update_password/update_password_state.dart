import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

class UpdatePasswordState {
  final loginService = SS.login;

  final isVisible = false.obs;

  //是否手机号验证
  final isPhone = true.obs;

  //修改登录/修改支付
  final isLogin = true.obs;
}
