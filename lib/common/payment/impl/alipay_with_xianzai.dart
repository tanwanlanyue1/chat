import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/payment/model/payment_enum.dart';
import 'package:guanjia/common/payment/model/trade_order.dart';

import '../payment_interface.dart';
import 'alipay_app_payment.dart';

///支付宝 - 现在付
class AlipayWithXianZai extends AlipayAppPayment {

  AlipayWithXianZai() : super(PaymentPlatform.xianzai);
}