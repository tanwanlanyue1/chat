import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mine_evaluate_controller.dart';

//我的评价
class MineEvaluatePage extends StatelessWidget {
  MineEvaluatePage({Key? key}) : super(key: key);

  final controller = Get.put(MineEvaluateController());
  final state = Get.find<MineEvaluateController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
