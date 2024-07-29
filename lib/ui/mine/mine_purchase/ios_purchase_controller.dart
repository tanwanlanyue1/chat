import 'package:get/get.dart';
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/payment/pre_order_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_purchase_controller.dart';
import 'mine_purchase_state.dart';
import 'payment/in_app_purchase_mixin.dart';
import 'widget/purchase_success_dialog.dart';

class IOSPurchaseController extends MinePurchaseController
    with InAppPurchaseMixin<RechargeAmountItem> {

  @override
  void onInit() {
    super.onInit();
    //监听选中的充值项，计算订单价格和应付价格
    autoDisposeWorker(ever(state.selectedAmountItemIdRx, (_) => _computeOrderAmount()));
  }

  ///计算应付金额
  void _computeOrderAmount(){
    final amount = state.selectedAmountItemRx?.price.toDouble() ?? 0;
    paymentState.orderAmountRx.value = amount;
    paymentState.payableAmountRx.value = amount;
  }

  ///立即支付
  @override
  Future<void> payNow() async {
    final item = state.selectedAmountItemRx;
    final id = item?.id;
    if (item == null || id == null) {
      Loading.showToast("请选择充值金额");
      return;
    }

    final paymentMethod = paymentState.selectedChannelRx;
    if (paymentMethod == null) {
      return Loading.showToast('没有可用的支付方式');
    }

    Loading.show();
    final response = await PaymentApi.createOrder(
      payChannelId: paymentMethod.id,
      configId: id,
      type: 3,
    );
    Loading.dismiss();
    if (!response.isSuccess) {
      response.showErrorMessage();
      return;
    }
    final preOrder = PreOrderModel.fromJson(response.data);
    state.orderNo = preOrder.orderNo;
    inAppBuy(
        id: id, productId: item.productId, orderNo: preOrder.orderNo);
  }

  @override
  Future<RechargeAmountItem?> inAppVerifyPurchase(PurchaseDetails details) async {
    final item = state.rechargeAmountListRx
        .firstWhereOrNull((element) => element.productId == details.productID);
    if (item == null) {
      Loading.showToast('支付商品没找到，支付失败');
      AppLogger.d(
          'inAppVerifyPurchase： 支付商品没找到, details.productID=${details.productID}');
      return null;
    }
    final response = await PaymentApi.applePay(
        orderNo: state.orderNo,
        productId: item.productId,
        transactionReceipt: details.verificationData.serverVerificationData);
    //code = 0订单校验成功，1078订单已存在,1079订单不存在，1080订单校验失败
    if (response.isSuccess || response.code == 1078) {
      return item;
    }
    response.showErrorMessage();
    return null;
  }

  @override
  void onTransactionComplete(product) {
    fetchData(showLoading: false);
    PurchaseSuccessDialog.show(product.totalCoinValue);
  }
}
