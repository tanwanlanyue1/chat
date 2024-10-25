import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'plaza_state.dart';

class PlazaController extends GetxController with GetSingleTickerProviderStateMixin {
  final PlazaState state = PlazaState();
  late TabController tabController;


  @override
  void onInit() {
    SS.location.reportPosition();
    tabController = TabController(length: state.tabBarList.length, vsync: this,initialIndex: state.tabIndex.value);
    super.onInit();
  }

}
