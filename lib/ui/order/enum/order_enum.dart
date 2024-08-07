import 'package:collection/collection.dart';

enum OrderListType {
  going,
  cancel,
  finish;

  static OrderListType valueForIndex(int index) {
    return OrderListType.values.elementAtOrNull(index) ?? OrderListType.going;
  }

  static OrderListType valueForName(String name) {
    return OrderListType.values
            .firstWhereOrNull((element) => element.name == name) ??
        OrderListType.going;
  }
}

enum OrderItemType {
  waitingConfirm, // 等待确认
  waitingAssign, // 指派
  waitingPaymentForUser, // 等待用户支付
  waitingPaymentForBeauty, // 等待佳丽支付
  going, // 进行中
  cancelForUser, // 用户取消
  cancelForBeauty, // 佳丽取消
  timeOut, // 超时
  finish, // 完成
  waitingEvaluation; // 等待评价

  static OrderItemType valueForIndex(int index) {
    return OrderItemType.values.elementAtOrNull(index) ?? OrderItemType.finish;
  }
}

enum OrderOperationType {
  none, // 无操作
  confirm, // 接单
  assign, // 分配
  payment, // 支付
  cancel, // 取消
  finish, // 完成
  connect, // 联系
  evaluation, // 评价
}
