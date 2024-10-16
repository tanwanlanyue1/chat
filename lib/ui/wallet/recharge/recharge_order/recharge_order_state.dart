import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wallet/order_list/wallet_order_list_state.dart';

class RechargeOrderState {

  ///订单信息
  final orderRx = Rxn<PaymentOrderModel>();

  ///订单状态
  WalletOrderStatus? get orderStatusRx{
    return orderRx()?.orderStatus.let(WalletOrderStatus.valueOf);
  }

  ///提示文本
  String get descRx => SS.appConfig.configRx()?.payTips ?? '';

  RechargeOrderState() {
    ///Initialize variables
  }
}
