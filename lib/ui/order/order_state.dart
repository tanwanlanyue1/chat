import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

class OrderState {
  final titleList = [
    S.current.underway,
    S.current.canceled,
    S.current.completed,
  ];

  final selectIndex = 0.obs;

  final days = [
    {'label': S.current.summaryDay, 'value': 0},
    {'label': '3${S.current.day}', 'value': 3},
    {'label': '7${S.current.day}', 'value': 7},
    {'label': '15${S.current.day}', 'value': 15},
    {'label': '30${S.current.day}', 'value': 30},
  ];

  // 当前选择天数
  var selectDay = 0.obs;

  // 是否显示天数选择器
  final isShowDay = false.obs;
}
