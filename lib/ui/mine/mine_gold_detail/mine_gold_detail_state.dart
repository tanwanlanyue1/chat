import 'package:get/get.dart';

class MineGoldDetailState {
  // 当前选择记录类型 0:充值记录, 1:交易记录
  final recordSelectType = 0.obs;

  // 当前选择交易记录子类型 0:收益, 1:支出
  final dealSelectType = 1.obs;

  // 当前选择日期
  final dateString = "".obs;

  // 当前收益或者支出
  String amountString = "";

  List<String> dealItems = [
    "收益",
    "支出",
  ];

  List<String> items = [
    "",
    "",
    "",
  ];
}
