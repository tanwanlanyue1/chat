import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CharmPutResultController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isAnimation = true.obs;
  final isCardVisible = false.obs;

  late AnimationController controller;
  late Animation<double> animation;

  void startAnimation() async {
    isCardVisible.value = true;
    await controller.forward().orCancel;
    await controller.reverse().orCancel;
    isAnimation.value = false;

    update();
  }

  void clearState() {
    isAnimation.value = true;
    isCardVisible.value = false;
  }

  @override
  void onInit() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
