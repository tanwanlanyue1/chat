import 'package:get/get.dart';

class OrderState {
  final titleList = [
    "进行中",
    '已取消',
    '已完成',
  ];

  final selectedIndex = 0.obs;

  OrderState() {
    ///Initialize variables
  }
}
