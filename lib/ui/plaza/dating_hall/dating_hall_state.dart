import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

import '../../../common/network/api/api.dart';

class RectifyTheWorkplaceState {
  final info = SS.login.info?.copyWith().obs;
  //速配
  List speedDating = [
    {
      "name":S.current.videoDating,
      "subtitle":"面对面交流情感",
      "image":"assets/images/plaza/video_back.png",
    },
    {
      "name":S.current.voiceDating,
      "subtitle":"用声音探索灵魂",
      "image":"assets/images/plaza/voice_back.png",
    },
  ];

  int filtrateIndex = -1;
  //筛选类型
  List filtrateType = [
    {
      "name":"男士",
      "image":"assets/images/plaza/man_no.png",
      "activeImage":"assets/images/plaza/man.png",
    },
    {
      "name":"女士",
      "image":"assets/images/plaza/woman_no.png",
      "activeImage":"assets/images/plaza/woman.png",
    },
  ];
  final int ageMin = 16;
  final int ageMax = 65;
  //风格
  List<LabelModel> styleList = [];
  //风格-标签
  List<int> labelList = [];
}
