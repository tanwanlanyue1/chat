import 'package:get/get.dart';

class OrderListState {
  final waitTimeCount = 0.obs; // 等待超时
  final otherCancelCount = 0.obs; // 对方取消
  final selfCancelCount = 0.obs; // 主动取消
  final evaluateCount = 0.obs; // 已完成待评价
  final completeCount = 0.obs; // 已完成已评价
  final allCompleteCount = 0.obs; // 已完成
}
