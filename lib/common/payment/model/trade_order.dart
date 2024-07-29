import 'package:guanjia/common/payment/model/payment_enum.dart';

import '../payment_interface.dart';

///境修币充值订单
class RechargeOrder extends TradeOrder {

  @override
  PaymentChannelType channelType;

  @override
  int channelId;

  ///充值产品ID
  final int? productId;

  ///自定义充值币的数量
  final int? coin;

  ///境修币充值订单
  ///- channelType 支付渠道
  ///- channelId 渠道ID
  ///- productId 充值产品ID
  ///- coin 自定义充值币的数量
  RechargeOrder({
    required this.channelType,
    required this.channelId,
    this.productId,
    this.coin,
  });
}
