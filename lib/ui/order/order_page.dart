import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_controller.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final controller = Get.put(OrderController());
  final state = Get.find<OrderController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("订单"),
      ),
      body: Container(),
    );
  }
}
