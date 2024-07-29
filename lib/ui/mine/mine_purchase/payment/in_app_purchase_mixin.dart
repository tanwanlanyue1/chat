import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'data/entity/in_app_purchase_order.dart';
import 'in_app_purchase_loading.dart';

///应用内购处理Mixin（目前仅处理iOS应用内购）<br/>
///正常流程: inAppBuy() -> _onPurchaseUpdated(pending) -> inAppPendingPurchase() -> _onPurchaseUpdated(purchased) -> inAppVerifyPurchase() -> completePurchase()
mixin InAppPurchaseMixin<T> on DisposableInterface {
  StreamSubscription<List<PurchaseDetails>>? _inAppPurchaseSubscription;
  final _pendingOrderMaps = <String, InAppPurchaseOrder>{};
  final isInAppPurchaseLoadingRx = false.obs;
  final inAppPurchaseMessageRx = ''.obs;

  void _setLoading(bool value, [String? message]) {
    isInAppPurchaseLoadingRx.value = value;
    if (message != null) {
      inAppPurchaseMessageRx.value = message;
    }
    if (value) {
      InAppPurchaseLoading.show(inAppPurchaseMessageRx);
    } else {
      InAppPurchaseLoading.dismiss();
    }
  }

  ///等待完成的订单
  Set<String> get pendingOrderNoUuid => Set.of(_pendingOrderMaps.keys);

  @override
  void onInit() {
    _inAppPurchaseSubscription =
        InAppPurchase.instance.purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      _inAppPurchaseSubscription?.cancel();
      debugPrint('InAppPurchaseMixin($hashCode) > onDone');
    }, onError: (error) {
      debugPrint('InAppPurchaseMixin($hashCode): $error');
    });
    super.onInit();
  }

  ///购买状态更新回调
  void _onPurchaseUpdated(List<PurchaseDetails> list) async {
    debugPrint('InAppPurchaseMixin($hashCode) > _onPurchaseUpdated: ${list.length}');

    for (var details in list) {
      debugPrint('InAppPurchaseMixin($hashCode) > _onPurchaseUpdated  details.orderNoUuid: ${details.orderNoUuid}');

      final orderNoUuid = details.orderNoUuid;

      //排除不属于通过当前对象的buy方法购买的商品
      if (orderNoUuid == null || !_pendingOrderMaps.containsKey(orderNoUuid)) {
        continue;
      }

      debugPrint('InAppPurchaseMixin($hashCode) > _onPurchaseUpdated status: ${details.status}');

      switch (details.status) {
        case PurchaseStatus.pending:
          _setLoading(true, '等待交易完成');
          await _inAppPendingPurchase(details);
          break;
        case PurchaseStatus.purchased:
          //支付成功开始验证订单
          await _inAppVerifyPurchase(details, false);
          break;
        case PurchaseStatus.error:
          debugPrint(
              'InAppPurchaseMixin($hashCode) > _onPurchaseUpdated > error: ${details.error}');
          Loading.showToast('支付失败');
          break;
        case PurchaseStatus.restored:
          // 新设备恢复订阅成功
          break;
        case PurchaseStatus.canceled:
          Loading.showToast('支付取消');
          break;
      }

      //标记购买已完成
      if (details.pendingCompletePurchase) {
        debugPrint('InAppPurchaseMixin($hashCode) > _onPurchaseUpdated > completePurchase');
        await InAppPurchase.instance.completePurchase(details);
      }

      if (details.status != PurchaseStatus.pending) {
        _pendingOrderMaps.remove(orderNoUuid);
        _setLoading(false, '');
      }
    }
  }

  Future<void> _inAppVerifyPurchase(PurchaseDetails details, [bool isRetry = false]) async {
    try {
      _setLoading(true, isRetry ? '正在重新验证支付订单' : '支付成功，正在验证支付订单');
      final result = await inAppVerifyPurchase(details);
      _setLoading(false, '');
      if (result == null) {
        throw PaymentException('支付订单验证失败');
      } else {
        // InAppPurchaseFallback.instance.removeOrder(details.orderNoUuid ?? '');
        onTransactionComplete(result);
      }
    } catch (ex) {
      debugPrint('InAppPurchaseMixin($hashCode) > inAppVerifyPurchase > error: $ex');
      await _showVerifyPurchaseRetryDialog(details);
    }
  }

  ///验证支付失败，重试对话框
  Future<void> _showVerifyPurchaseRetryDialog(PurchaseDetails details) async {
    final result = await ConfirmDialog.show(
      okButtonText: const Text('重新验证'),
      message: const Text('验证支付失败，请点击重试按钮尝试重新验证，如果重试后还是失败，请联系客服处理。'),
    );
    if (result) {
      await _inAppVerifyPurchase(details, true);
    } else {
      ConfirmDialog.alert(
        okButtonText: const Text('知道了'),
        message: const Text('验证支付失败，请联系客服处理。'),
      ).ignore();
    }
  }

  ///1 发起应用内购买
  ///- id 应用后台定义的商品唯一ID
  ///- productId 苹果内购商品ID
  ///- orderNo 订单ID
  Future<bool> inAppBuy({
    required int id,
    required String productId,
    required String orderNo,
  }) async {
    debugPrint('InAppPurchaseMixin($hashCode) > inAppBuy > productId : $productId');
    _setLoading(true, '正在发起支付请求');
    try {
      await _maybeClearTransactions();

      //1查询支付商品详情
      final response = await InAppPurchase.instance.queryProductDetails({productId});
      if (response.error != null) {
        throw PaymentException('查询支付商品失败', response.error);
      }
      if (response.productDetails.isEmpty) {
        throw PaymentException('支付商品不存在');
      }
      final productDetails = response.productDetails.first;

      //2发起购买请求(购买消耗型商品并自动消耗)
      final param = PurchaseParam(productDetails: productDetails, applicationUserName: orderNo.uuid);
      final buyResult =
          await InAppPurchase.instance.buyConsumable(purchaseParam: param, autoConsume: true);
      if (!buyResult) {
        throw PaymentException('发起支付请求失败');
      }

      _pendingOrderMaps[orderNo.uuid] = InAppPurchaseOrder(
        id: id,
        productId: productId,
        orderNo: orderNo,
        createTimeMs: DateTime.now().millisecondsSinceEpoch,
      );

      debugPrint('InAppPurchaseMixin($hashCode) > buy > buyResult : $buyResult');
      return true;
    } catch (exception) {
      debugPrint('InAppPurchaseMixin($hashCode) > buy > exception : $exception');
      _setLoading(false, '');
      var errMsg = '支付失败';
      if (exception is PaymentException) {
        errMsg = exception.message;
      }
      Loading.showToast(errMsg);
      return false;
    }
  }

  ///2 iOS弹出支付对话框，等待用户操作
  Future<void> _inAppPendingPurchase(PurchaseDetails details) async {
    final order = _pendingOrderMaps[details.orderNoUuid ?? ''];
    if (order != null) {
      // await InAppPurchaseFallback.instance.saveOrder(order);
    }
  }

  ///3 用户已支付成功，客户端需提交购买信息至后台服务器，确认支付完成
  ///- 交易成功时，返回交易的产品信息，交易失败返回null
  Future<T?> inAppVerifyPurchase(PurchaseDetails details);

  ///4交易完成
  ///- product 交易产品
  void onTransactionComplete(T product);

  ///清理未完成的交易
  Future<void> _maybeClearTransactions() async {
    if (Platform.isIOS) {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      for (var item in transactions) {
        debugPrint('InAppPurchaseMixin($hashCode) > _maybeClearTransactions > item : $item');
        await paymentWrapper.finishTransaction(item);
      }
    }
  }

  @override
  void onClose() {
    _inAppPurchaseSubscription?.cancel();
    super.onClose();
  }
}

extension on PurchaseDetails {
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'pendingCompletePurchase': pendingCompletePurchase,
      'productID': productID,
      'purchaseID': purchaseID,
      'transactionDate': transactionDate,
      'verificationData': verificationData.toJson(),
    };
  }
}

extension PurchaseVerificationDataX on PurchaseVerificationData {
  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'localVerificationData': localVerificationData,
      'serverVerificationData': serverVerificationData,
    };
  }
}

extension AppStorePurchaseDetailsX on AppStorePurchaseDetails {
  void printDetails() {
    final builder = StringBuffer();
    builder.writeln();
    builder.writeln('productID: $productID');
    builder.writeln('purchaseID: $purchaseID');
    builder.writeln('transactionDate: $transactionDate');
    builder.writeln('status: $status');
    builder.writeln('error: $error');
    builder.writeln('pendingCompletePurchase: $pendingCompletePurchase');
    builder.writeln('verificationData: ${verificationData.toJson()}');
    builder.writeln('skPaymentTransaction: $skPaymentTransaction');
    print('printDetails: ${builder.toString()}');
  }
}

class PaymentException implements Exception {
  final String message;
  final dynamic error;

  PaymentException(this.message, [this.error]);

  @override
  String toString() {
    return 'PaymentException{message: $message, error: $error}';
  }
}

extension PurchaseDetailsX on PurchaseDetails {
  String? get orderNoUuid {
    if (this is AppStorePurchaseDetails) {
      //注意：发起支付时设置的applicationUsername在杀进程，重新打开app后有可能会被清空，不一定有值
      return (this as AppStorePurchaseDetails).skPaymentTransaction.payment.applicationUsername;
    }
    return null;
  }
}
