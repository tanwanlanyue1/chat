import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';
import 'package:guanjia/generated/l10n.dart';

class OrderPaymentState {

  final datingModel = Rxn<OrderItemModel>();

  final vipModel = Rxn<PaymentOrderInfoModel>();

  final selectIndex = Rxn<int>();

  final countDown = 0.obs;

  final list = [
    OrderPaymentListItem(
      icon: "assets/images/order/guanjia.png",
      title: S.current.smallTreasuryPayment,
    ),
    OrderPaymentListItem(
      icon: "assets/images/order/usdt.png",
      title: S.current.USDTPayment,
      detail: S.current.recommendUserUse,
    ),
    OrderPaymentListItem(
      icon: "assets/images/order/eth.png",
      title: S.current.ETHPayment,
      detail: S.current.recommendUserUse,
    ),
    OrderPaymentListItem(
      icon: "assets/images/order/unionpay.png",
      title: S.current.unionPay,
      detail: S.current.recommendUnionUse,
    ),
  ];
}

class OrderPaymentListItem {
  OrderPaymentListItem({
    required this.icon,
    required this.title,
    this.detail,
  });

  final String icon;
  final String title;
  final String? detail;
}
