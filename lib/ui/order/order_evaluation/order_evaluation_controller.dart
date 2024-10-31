import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/widgets/label_widget.dart';
import 'package:guanjia/widgets/loading.dart';

import 'order_evaluation_state.dart';

class OrderEvaluationController extends GetxController
    with OrderOperationMixin {
  final OrderEvaluationState state = OrderEvaluationState();

  final loginService = SS.login;

  late final TextEditingController otherController;

  @override
  void onInit() {
    SS.appConfig.configRx.value?.labels?.forEach((element) {
      state.labelItems.add(LabelItem(
        id: element.id,
        title: element.tag,
        icon: element.icon,
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

    final selectedIdString = state.labelItems
        .where((item) => item.selected)
        .map((item) => item.id.toString())
        .join(',');

    Loading.show();
    final res = await OrderApi.evaluate(
      orderId: args,
      content: otherController.text,
      tag: selectedIdString,
      score: state.starIndex.value,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    Get.back();
  }
}
