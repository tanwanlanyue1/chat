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

  //约会背景色
  List backColor = [
    {
      "begin": AppColor.blueC1,
      "end": AppColor.blueE2,
    },
    {
      "begin": AppColor.pinkBD,
      "end": AppColor.pinkFD,
    },
    {
      "begin": AppColor.greenE7,
      "end": AppColor.greenCD,
    },
    {
      "begin": AppColor.yellowFE,
      "end": AppColor.yellowFB,
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
