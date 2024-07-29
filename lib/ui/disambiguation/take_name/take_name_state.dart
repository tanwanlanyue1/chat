
import '../../../common/network/api/api.dart';

class TakeNameState {
  bool sex = true;//性别
  bool beBorn = true;//出生
  bool focus = false;//焦点

  //生日
  List<String> birthdayList = [];
  List<String> solarList = [];
  //生日
  String birthday = "";

  int costGold = 0;//消费境修币

  //广播
  List<AdvertisingStartupModel> carousel = [];
}
