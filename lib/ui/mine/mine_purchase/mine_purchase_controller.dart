import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/payment/payment_mixin.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/mine_purchase/android_purchase_controller.dart';
import 'package:guanjia/ui/mine/mine_purchase/ios_purchase_controller.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_purchase_state.dart';

abstract class MinePurchaseController extends GetxController  with GetAutoDisposeMixin, PaymentMixin {
  final MinePurchaseState state = MinePurchaseState();

  static MinePurchaseController create(){
    return Platform.isIOS ? IOSPurchaseController() : AndroidPurchaseController();
  }

  final loginService = SS.login;

  final customQuantityInputController = TextEditingController();

  void onTapConfig(int id) {
    state.selectedAmountItemIdRx.value = id;
  }

  ///立即支付
  Future<void> payNow();

  @override
  void onInit() async {
    fetchData();
    super.onInit();
  }

  void fetchData({bool showLoading = true}) async{
    if(showLoading){
      Loading.show();
    }
    if(state.appConfigRx() == null){
      await SS.appConfig.fetchData();
    }
    await loginService.fetchLevelMoneyInfo();
    final configRes = await PaymentApi.configList(Platform.isAndroid ? 0 : 1);
    if(showLoading){
      Loading.dismiss();
    }
    if (!configRes.isSuccess) {
      configRes.showErrorMessage();
    }
    final list = (configRes.data ?? []).map(RechargeAmountItem.new).toList();
    state.rechargeAmountListRx.value = list;
    if(state.selectedAmountItemIdRx() == null){
      state.selectedAmountItemIdRx.value = list.firstOrNull?.id;
    }
  }
}
