import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_payment_result_controller.dart';

enum OrderPaymentResultType {
  success,
  fail,
}

class OrderPaymentResultPage extends StatelessWidget {
  OrderPaymentResultPage({
    super.key,
    this.type = OrderPaymentResultType.success,
  });

  final OrderPaymentResultType type;

  final controller = Get.put(OrderPaymentResultController());
  final state = Get.find<OrderPaymentResultController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // type == OrderPaymentResultType.success
          //     ? S.current.payment_success
          //     : S.current.payment_fail,
          type == OrderPaymentResultType.success ? "支付成功" : "支付失败",
        ),
      ),
      body: Container(),
    );
  }
}
