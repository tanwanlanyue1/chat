import 'package:get/get.dart';

class StarInquireState {
  //出生时间
  String birthday = "";
  List<String> birthdayList = [];

  Map allAddressPresent = {
    "presentAddress":'广东省广州市天河区',
    "province":'广东省',
    "city":'广州市',
    "town":'天河区',
  }; //现居地点

  bool sex = true; //性别
  int costGold = 0;//消费境修币
}
