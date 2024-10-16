import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/payment/talk_payment.dart';
import 'package:guanjia/generated/l10n.dart';

class OrderPaymentState {

  final datingModel = Rxn<OrderItemModel>();

  final vipModel = Rxn<PaymentOrderModel>();

  final selectIndex = Rxn<int>(0);

  final countDown = 0.obs;

  final list = [
    OrderPaymentListItem(
      icon: "assets/images/order/guanjia.png",
      title: S.current.smallTreasuryPayment,
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
