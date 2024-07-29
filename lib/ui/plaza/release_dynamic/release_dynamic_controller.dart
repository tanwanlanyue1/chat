import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'release_dynamic_state.dart';

class ReleaseDynamicController extends GetxController with GetSingleTickerProviderStateMixin {
  final ReleaseDynamicState state = ReleaseDynamicState();
  late TabController tabController;

  @override
  void onInit() {
    
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.onInit();
  }
}
