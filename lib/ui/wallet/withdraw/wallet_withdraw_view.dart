import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wallet_withdraw_controller.dart';

///提现
class WalletWithdrawView extends StatefulWidget {
  const WalletWithdrawView({super.key});

  @override
  State<WalletWithdrawView> createState() => _WalletWithdrawViewState();
}

class _WalletWithdrawViewState extends State<WalletWithdrawView> with AutomaticKeepAliveClientMixin {

  final controller = Get.put(WalletWithdrawController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }

  @override
  bool get wantKeepAlive => true;
}
