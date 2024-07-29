import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/today_cultivation_stats_model.dart';

class WoodenFishState {
  ///本次敲击次数
  final currentKnockOnRx = 0.obs;

  ///统计数据
  final statsRx = Rxn<TodayCultivationStatsModel>();

  ///今日敲击次数
  int get todayKnockOnRx =>
      (statsRx.value?.recitationCount ?? 0) + currentKnockOnRx.value;

  ///累计敲击次数
  int get totalKnockOnRx =>
      (statsRx.value?.sumRecitation ?? 0) + currentKnockOnRx.value;

  ///当前诵读的经文
  final buddhistSutrasRx = Rxn<BuddhistSutrasModel>();

  ///设置
  final settingRx = WoodenFishSetting.fromJson({}).obs;
}

///木鱼设置
class WoodenFishSetting {
  final bool isAutoKnockOn;
  final double frequency;
  final double musicVolume;

  WoodenFishSetting({
    required this.isAutoKnockOn,
    required this.frequency,
    required this.musicVolume,
  });

  factory WoodenFishSetting.fromJson(Map<String, dynamic> json) {
    return WoodenFishSetting(
      isAutoKnockOn: json['isAutoKnockOn'] ?? false,
      frequency: json['frequency'] ?? 0.5,
      musicVolume: json['musicVolume'] ?? 100.0,
    );
  }

  WoodenFishSetting copyWith({
    bool? isAutoKnockOn,
    double? frequency,
    double? musicVolume,
  }) {
    return WoodenFishSetting(
      isAutoKnockOn: isAutoKnockOn ?? this.isAutoKnockOn,
      frequency: frequency ?? this.frequency,
      musicVolume: musicVolume ?? this.musicVolume,
    );
  }

  Map<String, dynamic> toJson() => {
        'isAutoKnockOn': isAutoKnockOn,
        'frequency': frequency,
        'musicVolume': musicVolume,
      };
}
