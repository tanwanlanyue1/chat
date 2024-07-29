import 'charm_record.dart';

/// 当前用户符文信息
class CharmInfo {
  CharmInfo({
    required this.cost,
    required this.seconds,
    required this.lightCount,
    required this.blessCount,
    required this.svga,
    required this.millisecond,
    // required this.lastRecord,
  });

  final int cost; // 境修币 0=免费
  int seconds; // 下次免费倒计时 (秒)
  final int lightCount; // 当前用户剩余开光次数
  final int blessCount; // 当前用户剩余加持次数
  final String svga; // 动效地址
  final int millisecond; // 延迟播放本地动画时间（毫秒）
  // CharmRecord? lastRecord; // 上次符文记录

  factory CharmInfo.fromJson(Map<String, dynamic> json) {
    return CharmInfo(
      cost: json["cost"] ?? 0,
      seconds: json["seconds"] ?? 0,
      lightCount: json["lightCount"] ?? 0,
      blessCount: json["blessCount"] ?? 0,
      svga: json["svga"] ?? "",
      millisecond: json["millisecond"] ?? 0,
      // lastRecord: json["lastRecord"] == null
      //     ? null
      //     : CharmRecord.fromJson(json["lastRecord"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "seconds": seconds,
        "lightCount": lightCount,
        "blessCount": blessCount,
        "svga": svga,
        "millisecond": millisecond,
        // "lastRecord": lastRecord?.toJson(),
      };
}
