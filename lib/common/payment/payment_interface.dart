import 'model/payment_enum.dart';


///支付接口
abstract class PaymentInterface{

  ///支付方式
  final PaymentMethod paymentMethod;
  PaymentInterface(this.paymentMethod);

  ///发起支付
  ///- order  交易订单
  ///- return 支付结果
  Future<PayResult<T>> pay<T extends TradeOrder>(T order);

  ///清理资源
  void dispose(){}

}


///支付方式
class PaymentMethod{

  ///支付渠道类型
  final PaymentChannelType channelType;

  ///支付平台
  final PaymentPlatform platform;

  ///渠道ID
  final int id;

  PaymentMethod({required this.channelType,required this.platform, this.id = 0});

  @override
  int get hashCode => '$channelType-$platform'.hashCode;

  @override
  bool operator ==(Object other) {
    if(other is PaymentMethod){
      return other.hashCode == hashCode;
    }
    return super == other;
  }

}

///交易订单
abstract class TradeOrder{

  ///支付渠道
  PaymentChannelType get channelType;
  set channelType(PaymentChannelType value);

  ///渠道ID
  int get channelId;
  set channelId(int value);
}

///支付结果
class PayResult<T extends TradeOrder>{
  ///交易订单
  final T order;
  ///支付状态
  final PayStatus state;
  PayResult({required this.order,required this.state});

  factory PayResult.success(T order) => PayResult(order: order, state: PayStatus.success);
  factory PayResult.failed(T order) => PayResult(order: order, state: PayStatus.failed);
  factory PayResult.cancel(T order) => PayResult(order: order, state: PayStatus.cancel);

  @override
  String toString() {
    return 'PayResult{order: $order, state: $state}';
  }
}

///支付状态
enum PayStatus{
  ///支付成功
  success,

  ///支付失败
  failed,

  ///用户取消支付
  cancel,

  ///未知
  unknown,
}
