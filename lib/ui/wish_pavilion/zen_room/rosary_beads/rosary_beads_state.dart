import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_config_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_product_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/today_cultivation_stats_model.dart';
import 'package:guanjia/common/service/service.dart';

class RosaryBeadsState {

  ///本次敲击次数
  final currentKnockOnRx = 0.obs;

  ///统计数据
  final statsRx = Rxn<TodayCultivationStatsModel>();

  ///今日敲击次数
  int get todayKnockOnRx =>
      (statsRx.value?.beadsCount ?? 0) + currentKnockOnRx.value;

  ///累计敲击次数
  int get totalKnockOnRx =>
      (statsRx.value?.sumBeads ?? 0) + currentKnockOnRx.value;

  ///场景配置
  final configRx = Rx<RosaryBeadsConfigModel>(
    RosaryBeadsConfigModel(
      uid: SS.login.userId ?? 0,
      backgroundId: 0,
      beadsId: 0,
      sound: 1,
      way: 0,
      direction: 0,
      backgroundImg: '',
      beadsImg: '',
    ),
  );

  ///佛珠款式列表
  final rosaryBeadsList = <RosaryBeadsProductModel>[];

  ///底部栏是否展开
  final isExpandedRx = true.obs;

  ///初始化完成
  final isReadyRx = false.obs;
}

extension RosaryBeadsConfigModelX on RosaryBeadsConfigModel{

  ///念珠位置
  Alignment get alignment{
    switch(direction){
      case 1:
        return Alignment.centerLeft;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  ///是否开启音效
  bool get isSoundEnabled => sound == 0;
}
