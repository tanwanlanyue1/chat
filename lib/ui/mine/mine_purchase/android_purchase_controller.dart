import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/payment/model/trade_order.dart';
import 'package:guanjia/common/payment/payment_interface.dart';
import 'package:guanjia/ui/mine/mine_purchase/widget/purchase_success_dialog.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_purchase_controller.dart';

class AndroidPurchaseController extends MinePurchaseController  {

  /// 自定义充值数量
  final _customQuantityRx = ''.obs..firstRebuild = false;

  ///默认币种单价(元)
  static const _defaultUnitPrice = 0.1;

  @override
  void onInit() async {
    super.onInit();

    //监听选中的充值项和优惠券选中项，计算订单价格和应付价格
    autoDisposeWorker(everAll([state.rechargeAmountListRx,state.selectedAmountItemIdRx], (_) => _computeOrderAmount()));

    //监听自定义自定义充值数量，计算订单价格和应付价格
    customQuantityInputController.bindTextRx(_customQuantityRx);
    autoDisposeWorker(ever(_customQuantityRx, (_){
      state.selectedAmountItemIdRx.value = null;
      _computeOrderAmount();
    }));

    fetchData();

    super.onInit();
  }

  ///计算应付金额
  void _computeOrderAmount(){
    final value = (double.tryParse(_customQuantityRx.value) ?? 0) * (state.appConfigRx()?.goldPrice ?? _defaultUnitPrice);
    final amount = state.selectedAmountItemRx?.price.toDouble() ?? value;
    paymentState.orderAmountRx.value = amount;
    paymentState.payableAmountRx.value = amount;
  }


  ///立即支付
  @override
  Future<void> payNow() async {

    //检查自定义充值条件
    final customQuantity = int.tryParse(_customQuantityRx.value) ?? 0;
    final minimumQuantity = state.appConfigRx()?.minPayGold ?? 1;
    //是否是自定义充值
    final isCustomQuantity = state.selectedAmountItemIdRx() == null;
    if(isCustomQuantity && customQuantity > 0){
      if(customQuantity < minimumQuantity){
        return Loading.showToast('单笔最少充值$minimumQuantity境修币');
      }
    }
    if(isCustomQuantity && customQuantity <= 0){
      return Loading.showToast('请输入充值数量');
    }

    final paymentMethod = paymentState.selectedChannelRx;
    if (paymentMethod == null) {
      return Loading.showToast('请选择支付方式');
    }

    final order = RechargeOrder(
      channelId: paymentMethod.id,
      channelType: paymentMethod.channelType,
      productId: isCustomQuantity ? null : state.selectedAmountItemIdRx(),
      coin: isCustomQuantity ? customQuantity : null,
    );
    final totalCoinValue = state.selectedAmountItemRx?.totalCoinValue ?? customQuantity;
    Loading.show();
    final result = await doPay(paymentMethod: paymentMethod, order: order);
    Loading.dismiss();
    switch (result.state) {
      case PayStatus.success:
        fetchData(showLoading: false);
        PurchaseSuccessDialog.show(totalCoinValue);
        break;
      case PayStatus.cancel:
        Loading.showToast('支付取消');
        break;
      case PayStatus.unknown:
      case PayStatus.failed:
        break;
    }
  }

}
