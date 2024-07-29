import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:guanjia/common/utils/local_storage.dart';

import 'entity/in_app_purchase_order.dart';


class InAppPurchaseDao{
  static const _kUncompletedOrders = 'UncompletedOrders';

  final LocalStorage _storage;
  InAppPurchaseDao(String userId): _storage = LocalStorage('InAppPurchaseDao_$userId');

  ///获取未完成订单列表
  Future<List<InAppPurchaseOrder>> getUncompletedOrders() async {
    final list = (await _storage.getStringList(_kUncompletedOrders)) ?? <String>[];
    try{
      return list.map((e) => InAppPurchaseOrder.fromJson(jsonDecode(e))).whereNotNull().toList();
    }catch(ex){
      return [];
    }
  }

  ///保存订单
  Future<void> saveOrder(InAppPurchaseOrder order) async{
    final list = await getUncompletedOrders();
    list
      ..removeWhere((element) => element.orderNo == order.orderNo)
      ..add(order);
    final value = list.map((e) => jsonEncode(e.toJson())).toList();
    await _storage.setStringList(_kUncompletedOrders, value);
  }

  ///删除订单
  Future<void> removeOrder(String orderNo) async{
    final list = await getUncompletedOrders();
    list.removeWhere((element) => element.orderNo == orderNo);
    final value = list.map((e) => jsonEncode(e.toJson())).toList();
    await _storage.setStringList(_kUncompletedOrders, value);
  }

}