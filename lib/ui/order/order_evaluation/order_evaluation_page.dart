import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_evaluation_controller.dart';

class OrderEvaluationPage extends StatelessWidget {
  OrderEvaluationPage({Key? key}) : super(key: key);

  final controller = Get.put(OrderEvaluationController());
  final state = Get.find<OrderEvaluationController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('评价'),
      ),
    );
  }
}
