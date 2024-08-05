import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/order/order_page.dart';

class OrderPages {
  static final routes = [
    GetPage(
      name: AppRoutes.orderPage,
      page: () {
        return OrderPage();
      },
    ),
  ];
}
