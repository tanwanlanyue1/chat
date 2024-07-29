import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/payment/pre_order_model.dart';
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/common/payment/model/trade_order.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:wechat_kit/wechat_kit.dart';

import '../../utils/app_logger.dart';
import '../payment_interface.dart';

///微信 - 小程序支付
abstract class WechatMiniProgramPayment extends PaymentInterface
    with WidgetsBindingObserver {
  StreamSubscription? _payResultSubscription;
  StreamSubscription? _subscription;
  Completer<bool>? _appResumedCompleter;

  WechatMiniProgramPayment(super.paymentMethod);


  ///下单, 如果成功，则返回支付参数 return @nullable
  Future<PreOrderModel?> _placeOrder<T extends TradeOrder>(T order) async {
    try {
      final rechargeOrder = order as RechargeOrder;
      final response = await PaymentApi.createOrder(
        payChannelId: rechargeOrder.channelId,
        configId: rechargeOrder.productId,
        goldNum: rechargeOrder.coin,
        type: 2,
      );
      if (response.isSuccess) {
        return PreOrderModel.fromJson(response.data);
      } else{
        response.showErrorMessage();
      }
    } catch (ex) {
      debugPrint('微信下单失败，$ex');
      Loading.showToast('支付失败');
    }
    return null;
  }

  @override
  Future<PayResult<T>> pay<T extends TradeOrder>(T order) async {
    ///未安装微信
    if (!(await WechatKitPlatform.instance.isInstalled())) {
      Loading.showToast('未安装微信');
      return PayResult.failed(order);
    }
    try{
      final preOrder = await _placeOrder(order);
      final orderNo = preOrder?.orderNo;
      if (preOrder == null || orderNo == null || orderNo.isEmpty) {
        return PayResult.failed(order);
      }

      var baseUrl = ServerConfig.instance.getDefaultServer().api.toString();
      if(!AppInfo.isRelease){
        baseUrl = (await ServerConfig.instance.getServer()).api.toString();
      }
      final data = Uri.encodeComponent(jsonEncode({
        'orderNo': orderNo,
        'userId': SS.login.userId,
        'token': SS.login.token,
        'baseUrl': baseUrl,
        'isRelease': AppInfo.isRelease,
      }));
      await WechatKitPlatform.instance.launchMiniProgram(
        userName: AppConfig.miniProgramUsername,
        type: AppInfo.isRelease ? WechatMiniProgram.kRelease : WechatMiniProgram.kPreview,
        path: 'pages/payment/index?data=$data',
      );
      return _waitingForPayResult(order, preOrder);
    }catch(ex){
      AppLogger.w('拉起小程序失败, $ex');
      return PayResult.failed(order);
    }
  }

  ///等待交易结果
  Future<PayResult<T>> _waitingForPayResult<T extends TradeOrder>(T order, PreOrderModel preOrder) async {
    WidgetsBinding.instance
      ..removeObserver(this)
      ..addObserver(this);
    var state = PayStatus.unknown;

    ///监听小程序支付回调，有可能不会执行，因为用户在小程序支付后，可能直接通过手势返回了我们的APP，这里的回调只有在支付后点击小程序内部的返回按钮才会回调
    _payResultSubscription?.cancel();
    _payResultSubscription = WechatKitPlatform.instance.respStream().listen((event) {
      if (event is WechatLaunchMiniProgramResp) {
        _payResultSubscription?.cancel();
        final result = event.extMsg;
        switch(result){
          case '1':
            state = PayStatus.success;
            break;
          case '2':
            state = PayStatus.cancel;
            break;
          default:
            state = PayStatus.failed;
            break;
        }
        AppLogger.d('微信小程序支付返回值：$event');
      }
    });

    //等待应用从后台切换到前台，如果还是没收到支付返回值，则轮询支付状态
    _appResumedCompleter = Completer();
    if (await _appResumedCompleter?.future == true) {
      if (state == PayStatus.unknown) {
        state = await _fetchOrderState(preOrder);
      }
    }
    _payResultSubscription?.cancel();
    _subscription?.cancel();
    return PayResult<T>(order: order, state: state);
  }


  ///获取订单状态 0未付款 1已付款 2已退款
  Future<PayStatus> _fetchOrderState(PreOrderModel model) async {
    //尝试几次
    const count = 3;
    for (var i = 0; i < count; i++) {
      final response = await PaymentApi.getOrderState(model.orderNo);
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_appResumedCompleter?.isCompleted == false) {
      _appResumedCompleter?.complete(false);
    }
    _appResumedCompleter = null;
    _payResultSubscription?.cancel();
    _payResultSubscription = null;
    _subscription?.cancel();
    _subscription = null;
  }
}
