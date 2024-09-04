import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';

class OrderPaymentState {

  final datingModel = Rxn<OrderItemModel>();

  final vipModel = Rxn<PaymentOrderInfoModel>();

  final selectIndex = Rxn<int>();

  final countDown = 0.obs;

  final list = [
    OrderPaymentListItem(
      icon: "icon",
      title: "管佳小金库支付",
      detail: "享会员价，立减6元",
    ),
    OrderPaymentListItem(
      icon: "icon",
      title: "USDT支付",
      detail: "推荐管佳用户使用",
    ),
    OrderPaymentListItem(
      icon: "icon",
      title: "ETH支付",
      detail: "推荐管佳用户使用",
    ),
    OrderPaymentListItem(
      icon: "icon",
      title: "银联支付",
      detail: "推荐银行卡用户使用",
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
