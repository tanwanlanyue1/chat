import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wallet/order_list/wallet_order_list_page.dart';
import 'package:guanjia/ui/wallet/recharge/recharge_order/recharge_order_page.dart';
import 'package:guanjia/ui/wallet/wallet_page.dart';

import '../../../ui/wallet/recharge/recharge_order/recharge_order_controller.dart';

class WalletPages {
  static final routes = [
    GetPage(
      name: AppRoutes.walletPage,
      page: () {
        return WalletPage();
      },
    ),
    GetPage(
      name: AppRoutes.rechargeOrderPage,
      page: () {
        return RechargeOrderPage();
      },
      binding: BindingsBuilder.put(
        () => RechargeOrderController(
          orderNo: Get.getArgs('orderNo', ''),
          fromRechargePage: Get.getArgs('fromRechargePage', false),
        ),
      ),
    ),
    GetPage(
      name: AppRoutes.walletOrderListPage,
      page: () {
        return WalletOrderListPage(tabIndex: Get.getArgs('tabIndex', 0));
      },
    ),
  ];
}
