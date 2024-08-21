import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';

import 'order_payment_result_state.dart';

class OrderPaymentResultController extends GetxController {
  final OrderPaymentResultState state = OrderPaymentResultState();

  void toOrderDetail(int orderId) {
    Get.offNamed(AppRoutes.orderDetailPage, arguments: {"orderId": orderId});
  }
}
