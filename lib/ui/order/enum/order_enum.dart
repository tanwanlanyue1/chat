import 'package:collection/collection.dart';

enum OrderListType {
  going(1),
  cancel(4),
  finish(3);

  final int stateValue; // 订单状态 1进行中 3已完成 4已取消

  const OrderListType(this.stateValue);

  static final _stateValueToOrderListTypeMap =
      Map<int, OrderListType>.fromIterable(
    OrderListType.values,
    key: (e) => e.stateValue,
  );

  static OrderListType valueForStateValue(int stateValue) {
    return _stateValueToOrderListTypeMap[stateValue] ?? OrderListType.going;
  }

  static OrderListType valueForIndex(int index) {
    return OrderListType.values.elementAtOrNull(index) ?? OrderListType.going;
  }

  bool get isGoing => this == OrderListType.going;
  bool get isCancel => this == OrderListType.cancel;
  bool get isFinish => this == OrderListType.finish;
}

enum OrderItemType {
  waitingAcceptance, // 等待确认
  waitingAssign, // 指派
  waitingPaymentForRequest, // 等待发送方支付（用户）
  waitingPaymentForReceive, // 等待接收方支付（佳丽或者用户）
  waitingConfirmForRequest, // 等待发送方确认完成
  waitingConfirmForReceive, // 等待接收方确认完成
  cancelForRequest, // 发送方取消
  cancelForReceive, // 接收方取消
  timeOut, // 超时
  finish, // 完成
  waitingEvaluation; // 等待评价 目前只有用户普通订单存在评价

  static OrderItemType valueForIndex(int index) {
    return OrderItemType.values.elementAtOrNull(index) ?? OrderItemType.finish;
  }
}

enum OrderOperationType {
  none, // 无操作
  accept, // 接单
  assign, // 分配
  payment, // 支付
  cancel, // 取消
  cancelAndFinish, // 取消和完成
  finish, // 完成
  connect, // 联系
  evaluation, // 评价
}
