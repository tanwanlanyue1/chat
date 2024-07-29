import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'merit_cultivation_ranking_state.dart';

class MeritCultivationRankingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MeritCultivationRankingController({
    this.initialIndex = 0,
  });

  final int initialIndex;

  final MeritCultivationRankingState state = MeritCultivationRankingState();

  late final tabController = TabController(
    initialIndex: initialIndex,
    length: 2,
    vsync: this,
    animationDuration: Duration.zero,
  );

  @override
  void onInit() {
    

    print("????????$initialIndex?????");
    super.onInit();
  }
}
