import 'dart:io';

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';

class MinePurchaseState {

  ///可选充值金额项目列表
  final rechargeAmountListRx = <RechargeAmountItem>[].obs;

  ///当前选中的充值金额项目ID
  final selectedAmountItemIdRx = Rxn<int>();

  ///当前选中的充值金额项目
  RechargeAmountItem? get selectedAmountItemRx => rechargeAmountListRx.firstWhereOrNull((element) => element.id == selectedAmountItemIdRx.value);

  ///APP配置
  Rxn<AppConfigModel> appConfigRx = SS.appConfig.configRx;

  ///预支付订单ID
  var orderNo = '';
}


///充值金额
class RechargeAmountItem {
  final PaymentConfigRes data;

  ///唯一ID
  int get id => data.id;

  ///Apple内购产品ID
  String get productId => data.productId;

  ///购买的币数量
  int get coinValue => data.goldNum;

  ///币数量+赠送的数量
  int get totalCoinValue{
    if(isFirstRecharge){
      return data.goldNum;
    }else{
      return data.goldNum + data.gift;
    }
  }

  ///赠送文本
  String get giveText{
    if(isFirstRecharge){
      return '首充优惠';
    }
    if(data.gift > 0){
      return '送${data.gift}境修币';
    }
    return '';
  }

  ///售价（元）
  double get price {
    if (isFirstRecharge) {
      return data.firstPrice.toDouble();
    } else {
      return data.price.toDouble();
    }
  }


  ///是否是首充(Android才有)
  bool get isFirstRecharge => Platform.isAndroid && data.isFirst == 1;

  ///充值金额项目
  RechargeAmountItem(this.data);
}
