import 'package:collection/collection.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';
import 'package:guanjia/common/network/api/model/payment/withdraw_order_model.dart';

class WalletOrderListState {
  WalletOrderListState() {
    ///Initialize variables
  }
}

///充值订单
class WalletRechargeOrderItem extends WalletOrderItem<PaymentOrderModel>{
  WalletRechargeOrderItem(super.data);
  @override
  String get amount => data.amount.toCurrencyString();
  @override
  String get createTime => data.createTime.dateTime.format;
  @override
  String get orderNo => data.orderNo;
  @override
  int get status => data.orderStatus;
}

///提现订单
class WalletWithdrawOrderItem extends WalletOrderItem<WithdrawOrderModel>{
  WalletWithdrawOrderItem(super.data);
  @override
  String get amount => data.amount.toCurrencyString();
  @override
  String get createTime => data.createTime.dateTime.format;
  @override
  String get orderNo => data.id.toString();
  @override
  int get status => data.state;
  @override
  String get address => data.address;
}

abstract class WalletOrderItem<T>{
  final T data;
  WalletOrderItem(this.data);

  ///订单编号
  String get orderNo;

  ///订单金额
  String get amount;

  ///钱包地址
  String get address => '';

  ///下单时间
  String get createTime;

  ///订单状态(0交易中，1成功，2失败)
  int get status;
}


///钱包订单状态
enum WalletOrderStatus{

  ///待支付
  pending(0),

  ///成功
  success(1),

  ///超时过期
  expired(2);

  final int value;

  const WalletOrderStatus(this.value);

  static WalletOrderStatus? valueOf(int value){
    return WalletOrderStatus.values.firstWhereOrNull((element) => element.value == value);
  }

  bool get isPending => this == pending;
  bool get isExpired => this == expired;
  bool get isSuccess => this == success;
}