import 'package:get/get.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';

import 'order_payment_state.dart';

class OrderPaymentController extends GetxController with OrderOperationMixin {
  final OrderPaymentState state = OrderPaymentState();

  void onTapPaymentType(int index) {
    state.selectIndex.value = index;
  }

  @override
  Future<bool> onTapOrderPayment(int orderId) async {
    final res = await super.onTapOrderPayment(orderId);
    return res;
  }
}
