import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/network/api/model/payment/payment_order_info.dart';

class OrderPaymentResultState {
  final detailModel = Rxn<OrderItemModel>();

  final vipModel = Rxn<PaymentOrderInfoModel>();
}
