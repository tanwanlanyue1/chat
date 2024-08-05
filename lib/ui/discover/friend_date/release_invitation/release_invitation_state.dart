import 'package:get/get.dart';

class ReleaseInvitationState {

  //约会类型下标
  final typeIndex = 0.obs;
  //标签
  final labelList = [0,4].obs;

  final serve = false.obs;

  //约会类型
  List<Map<String, dynamic>> typeList = [
    {
      "title": "边玩边吃",
      "type": 0,
    },
    {
      "title": "同城周边",
      "type": 1,
    },
    {
      "title": "双飞国外",
      "type": 2,
    },
    {
      "title": "海上游轮",
      "type": 3,
    },
    {
      "title": "自驾游",
      "type": 4,
    },
    {
      "title": "商务陪伴",
      "type": 5,
    },
    {
      "title": "饭局宴席",
      "type": 5,
    },
  ];
  //标签
  List label = [
    "限女士1人", "限男士1人", "1人不限男女", "仅限同城",
    "夜不归", "放开玩", "我全包", "各自AA", "报销路费",
  ];
}
