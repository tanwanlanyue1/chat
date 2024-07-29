import 'dart:io';

class MineFeedbackState {
  int typeIndex = 0;

  List<Map<String, dynamic>> typeList = [
    {
      "title": "闪退、卡顿、黑屏/白屏",
      "type": 0,
    },
    {
      "title": "功能故障或者不可用",
      "type": 1,
    },
    {
      "title": "内容太少，找不到想要的",
      "type": 2,
    },
    {
      "title": "产品不好用，我有建议",
      "type": 3,
    },
    {
      "title": "页面、配色不好看",
      "type": 4,
    },
    {
      "title": "密码、隐私、欺诈等",
      "type": 5,
    },
    {
      "title": "其他问题",
      "type": 999,
    },
  ];

  List<File> imgList = [];
}
