import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/label_widget.dart';

import 'order_evaluation_state.dart';

class OrderEvaluationController extends GetxController {
  final OrderEvaluationState state = OrderEvaluationState();

  final loginService = SS.login;

  late final TextEditingController otherController;

  @override
  void onInit() {
    SS.appConfig.configRx.value?.labels?.forEach((element) {
      state.labelItems.add(LabelItem(
        id: element.id,
        title: element.tag,
      ));
    });

    otherController = TextEditingController();
    super.onInit();
  }

  void onTapLabel(LabelItem item) {
    item.selected = !item.selected;
    update();
  }

  void onTapStar(int index) {
    state.starIndex.value = index;
  }

  void onTapSubmit() async {
    final args = Get.arguments;
    if (args is! int) {
      return;
    }

    final res = await OrderApi.evaluate(orderId: args, score: 5);
    if (res.isSuccess) {
      res.showErrorMessage();
      return;
    }
  }
}
