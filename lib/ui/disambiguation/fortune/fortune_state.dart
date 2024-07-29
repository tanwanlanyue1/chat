import '../../../common/network/api/api.dart';

class FortuneState {
  bool sex = true;//性别
  bool focus = false;//焦点
  //测算类型
  List calculateType = [
    {"name":"财运运势"},
    {"name":"爱情运势"},
    {"name":"健康运势"},
    {"name":"事业学业"},
  ];
  //类型下标
  int calculateIndex = 0;
  //生日
  List<String> birthdayList = [];
  List<String> solarList = [];
  //生日
  String birthday = "";

  int costGold = 0;//消费境修币

  //广播
  List<AdvertisingStartupModel> carousel = [];
}
