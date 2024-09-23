import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/generated/l10n.dart';

class OrderPaymentState {

  final datingModel = Rxn<OrderItemModel>();

  final vipModel = Rxn<PaymentOrderInfoModel>();

  final selectIndex = Rxn<int>();

  final countDown = 0.obs;

  final list = [
    OrderPaymentListItem(
      icon: "icon",
      title: S.current.smallTreasuryPayment,
    ),
    OrderPaymentListItem(
      icon: "icon",
      title: S.current.USDTPayment,
      detail: S.current.recommendUserUse,
    ),
    OrderPaymentListItem(
      icon: "icon",
      title: S.current.ETHPayment,
      detail: S.current.recommendUserUse,
    ),
    OrderPaymentListItem(
      icon: "icon",
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
