import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wallet/order_list/wallet_order_list_page.dart';
import 'package:guanjia/ui/wallet/recharge/recharge_order/recharge_order_page.dart';
import 'package:guanjia/ui/wallet/recharge/wallet_recharge_page.dart';
import 'package:guanjia/ui/wallet/wallet_page.dart';

import '../../../ui/wallet/recharge/recharge_order/recharge_order_controller.dart';
import '../../../ui/wallet/wallet_controller.dart';

class WalletPages {
  static final routes = [
    GetPage(
      name: AppRoutes.walletPage,
      page: () {
        return WalletPage();
      },
      binding: BindingsBuilder.put(
            () => WalletController(
          moneyValue: Get.getArgs('moneyValue', 0),
          tabIndex: Get.getArgs('tabIndex', 2),
        ),
      ),
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
    GetPage(
      name: AppRoutes.walletRechargePage,
      page: () {
        return const WalletRechargePage();
      },
    ),
  ];
}
