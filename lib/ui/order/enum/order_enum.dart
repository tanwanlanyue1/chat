import 'package:collection/collection.dart';

/// 订单总列表类型
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

/// 征友订单item用户类型
enum OrderItemUserType {
  request, // 发送方
  receive, // 接收方
  agent; // 征友中也存在佳丽接单的状态，经纪人也能查看到相应订单并显示

  bool get isRequest => this == OrderItemUserType.request;
  bool get isReceive => this == OrderItemUserType.receive;
  bool get isAgent => this == OrderItemUserType.agent;
}

/// 订单item状态
enum OrderItemState {
  unknown, // 未知状态
  waitingAcceptance, // 等待确认
  waitingAssign, // 等待指派
  waitingPaymentForRequest, // 等待发送方支付（用户）
  waitingPaymentForReceive, // 等待接收方支付（佳丽或者用户）
  waitingConfirmForRequest, // 等待发送方确认完成
  waitingConfirmForReceive, // 等待接收方确认完成
  cancelForRequest, // 发送方取消
  cancelForReceive, // 接收方取消
  timeOut, // 超时
  finish, // 完成
  waitingEvaluation; // 等待评价 目前只有用户普通订单存在评价

  static OrderItemState valueForIndex(int index) {
    return OrderItemState.values.elementAtOrNull(index) ??
        OrderItemState.finish;
  }
}

/// 订单操作类型
enum OrderOperationType {
  none, // 无操作
  create, // 发起约会
  accept, // 接单
  assign, // 分配
  payment, // 支付
  confirm, //佳丽确认已到位
  cancel, // 取消
  cancelAndFinish, // 取消和完成
  finish, // 完成
  connect, // 联系
  evaluation, // 评价
}

/// 订单详情显示类型
enum OrderDetailDisplayType {
  number, // 订单编号
  request, // 下单用户
  receive, // 接单用户
  requestTime, // 下单时间
  receiveTime, // 接单时间
  finishTime, // 结束时间
  cancelTime, // 结束时间
  reason, // 原因
  margin, // 保证金
  requestServiceFee, // 用户缴纳服务费
  breachFeeProportion, // 违约金比例
  breachFee, // 违约金
  platformFeeProportion, // 平台收取比例
  platformFee, // 平台费
  receiveFee, // 接收方收取金额
  receiveFeeProportion, // 接收方收取比例
  agentFeeProportion, // 经纪人收取比例
  agentFee, // 经纪人介绍费
  amount, // 金额 不同身份状态显示不同
}

/// 订单支付类型
enum OrderPaymentType {
  dating, // 约会订单
  vip, // VIP订单
}
