import 'package:get/get.dart';

class BindingState {
  final isVisible = false.obs;

  //绑定手机/绑定邮箱
  final isPhone = true.obs;
  //0:手机，1:邮箱
  int currentIndex = -1;
}
