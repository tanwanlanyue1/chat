class LevelMoneyRes {
  LevelMoneyRes({
    required this.cavIcon,
    required this.cavLevel,
    required this.cavLevelName,
    required this.nextCavLevelName,
    required this.nextCavLevelExp,
    required this.cavExp,
    required this.cavExpDiff,
    required this.cavDayDiff,
    required this.mavLevel,
    required this.mavLevelName,
    required this.nextMavLevelName,
    required this.mavExp,
    required this.mavExpDiff,
    required this.mavDayDiff,
    required this.currentMavDay,
    required this.money,
  });

  final String cavIcon; // 修行等级图标
  final int cavLevel; // 修行等级
  final String cavLevelName; // 修行等级名称
  final String nextCavLevelName; // 下一修行等级名称
  final int nextCavLevelExp; // 下一修行等级经验值
  final int cavExp; // 修行值
  final int cavExpDiff; // 修行值距离下一等级的差值
  final int cavDayDiff; // 修行天数距离下一等级的差值
  final int mavLevel; // 功德等级
  final String mavLevelName; // 功德等级名称
  final String nextMavLevelName; // 功德等级名称
  final int mavExp; // 功德值
  final int mavExpDiff; // 功德值距离下一等级的差值
  final int mavDayDiff; // 功德天数距离下一等级的差值
  final int currentMavDay; // 累计修行天数
  final int money; // 境修币（包括冻结）

  factory LevelMoneyRes.fromJson(Map<String, dynamic> json) {
    return LevelMoneyRes(
      cavIcon: json["cavIcon"] ?? "",
      cavLevel: json["cavLevel"] ?? 0,
      cavLevelName: json["cavLevelName"] ?? "",
      nextCavLevelName: json["nextCavLevelName"] ?? "",
      nextCavLevelExp: json["nextCavLevelExp"] ?? 0,
      cavExp: json["cavExp"] ?? 0,
      cavExpDiff: json["cavExpDiff"] ?? 0,
      cavDayDiff: json["cavDayDiff"] ?? 0,
      mavLevel: json["mavLevel"] ?? 0,
      mavLevelName: json["mavLevelName"] ?? "",
      nextMavLevelName: json["nextMavLevelName"] ?? "",
      mavExp: json["mavExp"] ?? 0,
      mavExpDiff: json["mavExpDiff"] ?? 0,
      mavDayDiff: json["mavDayDiff"] ?? 0,
      currentMavDay: json["currentMavDay"] ?? 0,
      money: json["money"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "cavIcon": cavIcon,
        "cavLevel": cavLevel,
        "cavLevelName": cavLevelName,
        "nextCavLevelName": nextCavLevelName,
        "nextCavLevelExp": nextCavLevelExp,
        "cavExp": cavExp,
        "cavExpDiff": cavExpDiff,
        "cavDayDiff": cavDayDiff,
        "mavLevel": mavLevel,
        "mavLevelName": mavLevelName,
        "mavExp": mavExp,
        "mavExpDiff": mavExpDiff,
        "mavDayDiff": mavDayDiff,
        "currentMavDay": currentMavDay,
        "money": money,
      };
}
