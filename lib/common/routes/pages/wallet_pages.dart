import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/wallet/wallet/wallet_page.dart';

class WalletPages {
  static final routes = [
    GetPage(
      name: AppRoutes.walletPage,
      page: () {
        return WalletPage();
      },
    ),
  ];
}
