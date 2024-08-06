import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wallet_order_controller.dart';

class WalletOrderPage extends StatelessWidget {
  WalletOrderPage({Key? key}) : super(key: key);

  final controller = Get.put(WalletOrderController());
  final state = Get.find<WalletOrderController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
