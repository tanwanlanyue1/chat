import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_payment_controller.dart';

class OrderPaymentPage extends StatelessWidget {
  OrderPaymentPage({super.key});

  final controller = Get.put(OrderPaymentController());
  final state = Get.find<OrderPaymentController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("支付订单"),
      ),
      body: Container(),
    );
  }
}
