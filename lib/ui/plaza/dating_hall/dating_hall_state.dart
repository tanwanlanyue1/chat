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
      "subtitle": S.current.communicateEmotionsFace,
      "image":"assets/images/plaza/voice_back.png",
      "text":"assets/images/plaza/voice_text.png",
      "isVideo": true,
      "color":[
        0xff8A8CFF,
        0xff1A49FE,
      ],
    },
    {
      "name":S.current.voiceDating,
      "subtitle": S.current.exploreSoulSound,
      "image":"assets/images/plaza/video_back.png",
      "text":"assets/images/plaza/video_text.png",
      "isVideo": false,
      "color":[
        0xffFF98F5,
        0xffC701C3,
      ],
    },
  ];

  int? filtrateIndex;
  //筛选类型
  List filtrateType = [
    {
      "name": S.current.questionMan,
      "activeImage":"assets/images/plaza/man.png",
      "type": 1,
    },
    {
      "name": S.current.questionWoman,
      "activeImage":"assets/images/plaza/woman.png",
      "type": 2,
    },
    {
      "name": S.current.all,
      "image":"assets/images/plaza/man.png",
      "activeImage":"assets/images/plaza/woman.png",
      "type": 0,
    },
  ];
  final int ageMin = 16;
  final int ageMax = 65;
  //风格
  List<LabelModel> styleList = [];
  //风格-标签
  List<int> labelList = [];
}
