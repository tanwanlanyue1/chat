import 'package:get/get.dart';
import 'package:guanjia/ui/wallet/enum/wallet_enum.dart';

import 'wallet_state.dart';

class WalletController extends GetxController {
  final WalletState state = WalletState();

  void onTapOrder() {}

  void onTapOperation(WalletOperationType type) {
    state.typeIndex.value = type;
  }
}
