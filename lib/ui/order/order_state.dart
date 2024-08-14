import 'package:get/get.dart';

class OrderState {
  final titleList = [
    "进行中",
    '已取消',
    '已完成',
  ];

  final selectIndex = 0.obs;

  final days = [
    {'label': '汇总当天', 'value': 0},
    {'label': '3天', 'value': 3},
    {'label': '7天', 'value': 7},
    {'label': '15天', 'value': 15},
    {'label': '30天', 'value': 30},
  ];

  // 当前选择天数
  var selectDay = 0.obs;

  // 是否显示天数选择器
  final isShowDay = false.obs;
}
