import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

import '../../../../common/network/api/api.dart';

class ReleaseInvitationState {

  //约会类型下标
  final typeIndex = 0.obs;
  //标签
  final labelList = [].obs;

  final serve = false.obs;

  //时间选择
  int time = 0;
  int hour = 0;
  int startTime = 0;
  int endTime = 0;
  int startHour = 0;
  int endHour = 0;
  List<String> timeList = [];

  //约会类型
  List<Map<String, dynamic>> typeList = [
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

  //标签
  List<LabelModel> label = [];
}
