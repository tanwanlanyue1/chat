import 'dart:io';

class MineFeedbackState {
  int typeIndex = 0;

  List<Map<String, dynamic>> typeList = [
    {
      "title": "VIP制度",
      "type": 0,
    },
    {
      "title": "服务流程",
      "type": 1,
    },
    {
      "title": "活动营销",
      "type": 2,
    },
    {
      "title": "售后服务",
      "type": 3,
    },
    {
      "title": "我要投诉",
      "type": 4,
    },
    {
      "title": "其他",
      "type": 999,
    },
  ];

  List<File> imgList = [];
}
