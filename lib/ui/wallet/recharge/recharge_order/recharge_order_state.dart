import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';

class RechargeOrderState {

  ///订单信息
  final orderRx = Rxn<PaymentOrderModel>();

  ///订单状态
  RechargeOrderStatus? get orderStatusRx{
    return orderRx()?.orderStatus.let(RechargeOrderStatus.valueOf);
  }

  RechargeOrderState() {
    ///Initialize variables
  }
}

///充值订单状态
enum RechargeOrderStatus{

  ///待支付
  pending(0),

  ///成功
  success(1),

  ///超时过期
  expired(2);

  final int value;

  const RechargeOrderStatus(this.value);

  static RechargeOrderStatus? valueOf(int value){
    return RechargeOrderStatus.values.firstWhereOrNull((element) => element.value == value);
  }

  bool get isPending => this == pending;
  bool get isExpired => this == expired;
  bool get isSuccess => this == success;
}