import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_state.dart';

class RectifyTheWorkplaceState {

  //速配
  List speedDating = [
    {
      "name":S.current.videoDating,
      "image":"assets/images/plaza/video_back.png",
    },
    {
      "name":S.current.voiceDating,
      "image":"assets/images/plaza/voice_back.png",
    },
  ];

  int filtrateIndex = 0;
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

  //风格
  List styleList = [
    "温柔可人",
    "温柔可人",
    "温柔可人",
    "温柔可人",
    "温柔可人",
    "其他",
  ];
}
