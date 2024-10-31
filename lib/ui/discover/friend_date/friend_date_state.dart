import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

class FriendDateState {
  final userInfo = SS.login.info;
  //约会类型
  final typeIndex = Rx(-1);
  //排序类型
  final sortIndex = [].obs;

  //约会类型
  List<Map<String, dynamic>> typeList = [
    {
      "title": S.current.all,
    },
    {
      "title": S.current.playEat,
      "type": 1,
    },
    {
      "title": S.current.cityPerimeter,
      "type": 2,
    },
    {
      "title": S.current.flyAbroad,
      "type": 3,
    },
    {
      "title": S.current.seaCruise,
      "type": 4,
    },
    {
      "title": S.current.selfDrivingTour,
      "type": 5,
    },
    {
      "title": S.current.businessCompanionship,
      "type": 6,
    },
    {
      "title": S.current.dinnerBanquet,
      "type": 7,
    },
  ];

  //排序类型
  List sortList = [
    {
      "name": S.current.newest,
      "type": 1,
    },
    {
      "name": S.current.ladiesOnly,
      "type": 2,
    },
    {
      "name": S.current.provideService,
      "type": 3,
    },
  ];

}
