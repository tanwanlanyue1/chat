import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/order_detail/order_detail_controller.dart';
import 'package:guanjia/ui/order/order_detail/order_detail_page.dart';
import 'package:guanjia/ui/order/order_evaluation/order_evaluation_page.dart';
import 'package:guanjia/ui/order/order_page.dart';
import 'package:guanjia/ui/order/order_payment/order_payment_page.dart';
import 'package:guanjia/ui/order/order_payment_result/order_payment_result_page.dart';

class OrderPages {
  static final routes = [
    GetPage(
      name: AppRoutes.orderPage,
      page: () {
        return OrderPage();
      },
    ),
    GetPage(
      name: AppRoutes.orderDetailPage,
      page: () {
        return OrderDetailPage();
      },
      binding: BindingsBuilder(() {
        var args = Get.tryGetArgs("orderId");
        return Get.lazyPut(() =>
            OrderDetailController((args != null && args is int) ? args : 0));
      }),
    ),
    GetPage(
      name: AppRoutes.orderEvaluationPage,
      page: () {
        return OrderEvaluationPage();
      },
    ),
    GetPage(
      name: AppRoutes.orderPaymentPage,
      page: () {
        return OrderPaymentPage();
      },
    ),
    GetPage(
      name: AppRoutes.orderPaymentResultPage,
      page: () {
        return OrderPaymentResultPage();
      },
    ),
  ];
}
