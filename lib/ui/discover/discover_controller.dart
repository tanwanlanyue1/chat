import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'discover_state.dart';

class DiscoverController extends GetxController with GetSingleTickerProviderStateMixin {
  final DiscoverState state = DiscoverState();
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
