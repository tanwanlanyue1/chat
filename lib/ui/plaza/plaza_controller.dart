import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'plaza_state.dart';

class PlazaController extends GetxController with GetSingleTickerProviderStateMixin {
  final PlazaState state = PlazaState();
  late TabController tabController;


  @override
  void onInit() {
    tabController = TabController(length: state.tabBarList.length, vsync: this, );
    super.onInit();
  }

}
