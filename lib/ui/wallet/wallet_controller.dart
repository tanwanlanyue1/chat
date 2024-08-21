import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/wallet/enum/wallet_enum.dart';

import 'wallet_state.dart';

class WalletController extends GetxController {
  final WalletState state = WalletState();

  @override
  void onInit() {
    super.onInit();
    //刷新余额
    SS.login.fetchMyInfo();
  }

  void onTapOrder() {}

  void onTapOperation(WalletOperationType type) {
    state.typeIndex.value = type;
  }

  void onTapSubmitTopUp() {}

  void onTapSubmitOtherTopUp() {}

  void onTapSubmitTransfer() {}

  void onTapReload() {}

}
