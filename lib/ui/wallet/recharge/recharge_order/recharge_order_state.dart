import 'package:get/get.dart';

class RechargeOrderState {

  ///订单超时
  final orderStatusRx = RechargeOrderStatus.pending.obs;

  RechargeOrderState() {
    ///Initialize variables
  }
}

///充值订单状态
enum RechargeOrderStatus{

  ///待支付
  pending,

  ///超时过期
  expired,

  ///成功
  success;

  bool get isPending => this == pending;
  bool get isExpired => this == expired;
  bool get isSuccess => this == success;
}