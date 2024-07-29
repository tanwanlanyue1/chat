import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/payment/model/payment_enum.dart';
import 'package:guanjia/common/payment/model/trade_order.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../payment_interface.dart';

///支付宝 - APP支付
abstract class AlipayAppPayment extends PaymentInterface
    with WidgetsBindingObserver {
  Completer<bool>? _appResumedCompleter;

  AlipayAppPayment(PaymentPlatform platform)
      : super(PaymentMethod(
    channelType: PaymentChannelType.alipay,
    platform: platform,
  ));

  ///下单, 如果成功，则返回支付参数 return @nullable
  Future<AlipayPreOrder?> _placeOrder<T extends TradeOrder>(T order) async {
    try {
      final rechargeOrder = order as RechargeOrder;
      final response = await PaymentApi.createOrder(
        payChannelId: rechargeOrder.channelId,
        configId: rechargeOrder.productId,
        goldNum: rechargeOrder.coin,
        type: 1,
      );
      if (response.isSuccess) {
        final orderNo = response.data['tn']['orderNo'];
        final url = response.data['tn']['url'];
        return AlipayPreOrder(orderNo: orderNo, url: url);
      }else{
        response.showErrorMessage();
      }
    } catch (ex) {
      debugPrint('支付宝下单失败，$ex');
      Loading.showToast('支付失败');
    }
    return null;
  }

  @override
  Future<PayResult<T>> pay<T extends TradeOrder>(T order) async {
    try {
      final preOrder = await _placeOrder(order);
      if (preOrder == null) {
        return PayResult.failed(order);
      }
      final result = await launchUrlString(preOrder.url);
      if (!result) {
        return PayResult.failed(order);
      }
      return _waitingForPayResult(order, preOrder.orderNo);
    } catch (ex) {
      AppLogger.w('支付失败，$ex');
      return PayResult.failed(order);
    }
  }

  ///等待交易结果
  Future<PayResult<T>> _waitingForPayResult<T extends TradeOrder>(T order, String orderNo) async {
    WidgetsBinding.instance
      ..removeObserver(this)
      ..addObserver(this);

    //等待应用从后台切换到前台，则通过接口主动去查询订单状态
    _appResumedCompleter = Completer();
    var state = PayStatus.unknown;
    if (await _appResumedCompleter?.future == true) {
      state = await _fetchOrderState(orderNo);
    }
    return PayResult<T>(order: order, state: state);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_appResumedCompleter?.isCompleted == false) {
        _appResumedCompleter?.complete(true);
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        WidgetsBinding.instance.removeObserver(this);
      });
    }
  }

  ///获取订单状态 0未付款 1已付款 2已退款
  Future<PayStatus> _fetchOrderState(String orderNo) async {
    //尝试几次
    const count = 3;
    for (var i = 0; i < count; i++) {
      final response = await PaymentApi.getOrderState(orderNo);
      final data = response.data;
      if ([1, 2].contains(data)) {
        return PayStatus.success;
      } else if (i + 1 < count) {
        await Future.delayed(3.seconds);
      }
    }
    return PayStatus.unknown;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_appResumedCompleter != null && !_appResumedCompleter!.isCompleted) {
      _appResumedCompleter?.complete(false);
    }
    _appResumedCompleter = null;
  }
}

///支付宝预支付订单信息
class AlipayPreOrder {
  ///订单ID
  final String orderNo;
  ///支付跳转URL
  final String url;
  AlipayPreOrder({required this.orderNo, required this.url});
}