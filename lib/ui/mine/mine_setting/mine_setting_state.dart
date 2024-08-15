import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

class MineSettingState {

  //震动提醒
  final shake = false.obs;
  //铃声提醒
  final bell = true.obs;
  //用户是否绑定了手机号/邮箱
  // bool userBind = false;

  //语言代码列表
  List languageCodeList = [
    "zh",
    "en",
    "fr",
    "ja",
  ];

}
