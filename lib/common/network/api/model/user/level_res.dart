class LevelRes {
  LevelRes({
    required this.icon,
    required this.name,
    required this.requiredExp,
    required this.requiredDays,
  });

  final String icon; // 图标
  final String name; // 等级
  final int requiredExp; // 经验值
  final int requiredDays; // 升级累计需要天数

  factory LevelRes.fromJson(Map<String, dynamic> json) {
    return LevelRes(
      icon: json["icon"] ?? "",
      name: json["name"] ?? "",
      requiredExp: json["requiredExp"] ?? 0,
      requiredDays: json["requiredDays"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "name": name,
        "requiredExp": requiredExp,
        "requiredDays": requiredDays,
      };
}
