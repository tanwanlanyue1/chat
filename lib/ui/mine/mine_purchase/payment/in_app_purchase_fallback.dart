//
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:collection/collection.dart';
// import 'apple_pay_params_builder.dart';
// import 'data/entity/in_app_purchase_order.dart';
// import 'data/in_app_purchase_dao.dart';
//
// ///内购异常流程处理
// class InAppPurchaseFallback{
//   InAppPurchaseFallback._();
//
//   static final instance = InAppPurchaseFallback._();
//   var _isInitialized = false;
//   InAppPurchaseDao? _dao;
//   InAppPurchaseDao get _inAppPurchaseDao => _dao ??= InAppPurchaseDao(UserService.instance.userId.toString() ?? '');
//
//   void initialize(){
//     if(!_isInitialized) {
//       _isInitialized = true;
//       InAppPurchase.instance.purchaseStream.listen(_onCompletePurchasesUpdated);
//     }
//   }
//
//   ///处理交易状态更新
//   void _onCompletePurchasesUpdated(List<PurchaseDetails> list) async{
//
//     //只处理已完成交易
//     list = list.where((element) => element.status == PurchaseStatus.purchased).toList();
//     if(list.isEmpty){
//       return;
//     }
//
//     //由控制器处理的订单
//     final pendingOrderNoUuid = <String>{};
//     Get.tryFind<RechargeCenterController>(tag: CoinType.goldCoin.name)?.pendingOrderNoUuid.let(pendingOrderNoUuid.addAll);
//     Get.tryFind<RechargeCenterController>(tag: CoinType.silverCoin.name)?.pendingOrderNoUuid.let(pendingOrderNoUuid.addAll);
//     Get.tryFind<QuickRechargeController>(tag: CoinType.goldCoin.name)?.pendingOrderNoUuid.let(pendingOrderNoUuid.addAll);
//     Get.tryFind<QuickRechargeController>(tag: CoinType.silverCoin.name)?.pendingOrderNoUuid.let(pendingOrderNoUuid.addAll);
//
//     final uncompletedOrders = await _inAppPurchaseDao.getUncompletedOrders();
//     //Map<productId,List<order>>
//     final uncompletedOrderMaps = <String,List<InAppPurchaseOrder>>{};
//     for (var element in uncompletedOrders) {
//       if(pendingOrderNoUuid.contains(element.orderNo.uuid)){
//         continue;
//       }
//       final list = uncompletedOrderMaps[element.productId] ?? <InAppPurchaseOrder>[];
//       list.add(element);
//       uncompletedOrderMaps[element.productId] = list;
//     }
//
//     for(var details in list){
//
//       //排除控制器处理的订单
//       if(pendingOrderNoUuid.contains(details.orderNoUuid ?? '')){
//         continue;
//       }
//
//       //找不到对应订单，不可补单
//       final orders = uncompletedOrderMaps[details.productID];
//       final order = orders?.firstOrNull;
//       if(order == null){
//         continue;
//       }
//
//       //补单
//       final result = await _completePurchase(details: details, order: order);
//       if(result){
//         orders?.remove(order);
//         await removeOrder(order.orderNo);
//       }
//     }
//   }
//
//   ///完成交易
//   Future<bool> _completePurchase({required PurchaseDetails details, required InAppPurchaseOrder order}) async{
//     switch(order.orderType){
//       case PaymentOrderType.silverRecharge:
//       case PaymentOrderType.goldRecharge:
//         return await _completeRechargePurchase(details: details, order: order);
//       case PaymentOrderType.buyVip:
//         return await _completeVipPurchase(details: details, order: order);
//         break;
//       case PaymentOrderType.buyFansGroup:
//         break;
//       case PaymentOrderType.upgradeFansGroup:
//         break;
//     }
//     return false;
//   }
//
//   ///完成充值交易
//   Future<bool> _completeRechargePurchase({required PurchaseDetails details, required InAppPurchaseOrder order}) async{
//     final params = ApplePayParamsBuilder.createRechargeParams(
//       details: details,
//       orderNo: order.orderNo,
//       coinType: order.orderType == PaymentOrderType.goldRecharge ? CoinType.goldCoin : CoinType.silverCoin,
//       id: order.id,
//     );
//     debugPrint('充值请求参数:$params');
//     final response =  await TBUserApi.applePay(params);
//     UserService.instance.getBalance(isReset: true);
//
//     //标记购买已完成
//     if(response.isSuccess && details.pendingCompletePurchase){
//       await InAppPurchase.instance.completePurchase(details);
//     }
//
//     return response.isSuccess;
//   }
//
//   ///完成VIP开通交易
//   Future<bool> _completeVipPurchase({required PurchaseDetails details, required InAppPurchaseOrder order}) async{
//     final params = ApplePayParamsBuilder.createBuyVipParams(
//       details: details,
//       id: order.id,
//       orderNo: order.orderNo,
//     );
//     debugPrint('充值请求参数:$params');
//     final response =  await TBUserApi.applePay(params);
//     UserService.instance.fetchUserInfo();
//
//     //标记购买已完成
//     if(response.isSuccess && details.pendingCompletePurchase){
//       await InAppPurchase.instance.completePurchase(details);
//     }
//
//     return response.isSuccess;
//   }
//
//   ///删除本地交易订单
//   Future<void> removeOrder(String orderNo) async{
//     await _inAppPurchaseDao.removeOrder(orderNo);
//   }
//
//   ///保存交易订单到本地
//   Future<void> saveOrder(InAppPurchaseOrder order) async{
//     await _inAppPurchaseDao.saveOrder(order);
//   }
//
//   ///获取未完成订单列表
//   Future<List<InAppPurchaseOrder>> getUncompletedOrders(){
//     return _inAppPurchaseDao.getUncompletedOrders();
//   }
//
// }