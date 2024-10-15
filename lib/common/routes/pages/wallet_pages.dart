import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wallet/order_list/wallet_order_list_page.dart';
import 'package:guanjia/ui/wallet/recharge/recharge_order/recharge_order_page.dart';
import 'package:guanjia/ui/wallet/wallet_page.dart';

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
    ),
    GetPage(
      name: AppRoutes.walletOrderListPage,
      page: () {
        return WalletOrderListPage();
      },
    ),
  ];
}
