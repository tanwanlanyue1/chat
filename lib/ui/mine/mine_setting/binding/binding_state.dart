import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';

class BindingState {
  final isVisible = false.obs;

  //绑定手机/绑定邮箱
  final isPhone = true.obs;
  //0:手机，1:邮箱
  int currentIndex = -1;

  //手机号 国家码 +86
  var countryCode = '';
  var verificationId = '';

}
