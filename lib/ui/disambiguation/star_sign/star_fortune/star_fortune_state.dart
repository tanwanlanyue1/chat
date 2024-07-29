import 'package:get/get.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';

class StarFortuneState {
  //时间类型
  List timeType = [
    {
      "name":"今日",
      "timeType": 0,
    },
    {
      "name":"明日",
      "timeType": 1,
    },
    {
      "name":"本周",
      "timeType": 2
    },
    {
      "name":"本月",
      "timeType": 3,
    },
    {
      "name":"本年",
      "timeType": 4,
    },
  ];

  final timeIndex = 0.obs;//预测时间下标
  //星座
  Starts constellation = Starts(
      icon: "assets/images/disambiguation/aries.png",
      constellation: "aries",
      name: "白羊座",
      time: "03.21-04.19"
  );

  int costGold = 0;//消费境修币
}
