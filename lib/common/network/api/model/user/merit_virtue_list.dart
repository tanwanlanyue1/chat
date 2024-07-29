class MeritVirtueList {
  MeritVirtueList({
    required this.todayMav,
    required this.currentMav,
    required this.mavLog,
  });

  final int todayMav; // 今日功德值
  final int currentMav; // 当前月份累计功德值
  final List<MeritVirtueLog> mavLog; // 用户功德记录

  factory MeritVirtueList.fromJson(Map<String, dynamic> json) {
    return MeritVirtueList(
      todayMav: json["todayMav"] ?? 0,
      currentMav: json["currentMav"] ?? 0,
      mavLog: json["mavLog"] == null
          ? []
          : List<MeritVirtueLog>.from(
              json["mavLog"]!.map((x) => MeritVirtueLog.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "todayMav": todayMav,
        "currentMav": currentMav,
        "mavLog": mavLog.map((x) => x?.toJson()).toList(),
      };
}

class MeritVirtueLog {
  MeritVirtueLog({
    required this.id,
    required this.optType,
    required this.logType,
    required this.amount,
    required this.mavNum,
    required this.giftId,
    required this.giftName,
    required this.image,
    required this.giftNum,
    required this.extraName,
    required this.createTime,
  });

  final int id; // 记录ID
  final int optType; // 操作类型 1 收入（增加），2 支出（减少）
  final int logType; // 记录类型
  final int amount; // 变化数值
  final int mavNum; // 当前功德值
  final int giftId; // 礼物ID
  final String giftName; // 礼物名称
  final String image; // 礼物图片地址
  final int giftNum; // 礼物数量
  final String extraName; // 额外名称（目前logType=11,12时，是佛的名称）
  final String createTime; // 礼物图片地址

  factory MeritVirtueLog.fromJson(Map<String, dynamic> json) {
    return MeritVirtueLog(
      id: json["id"] ?? 0,
      optType: json["optType"] ?? 0,
      logType: json["logType"] ?? 0,
      amount: json["amount"] ?? 0,
      mavNum: json["mavNum"] ?? 0,
      giftId: json["giftId"] ?? 0,
      giftName: json["giftName"] ?? "",
      image: json["image"] ?? "",
      giftNum: json["giftNum"] ?? 0,
      extraName: json["extraName"] ?? "",
      createTime: json["createTime"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "optType": optType,
        "logType": logType,
        "amount": amount,
        "mavNum": mavNum,
        "giftId": giftId,
        "giftName": giftName,
        "image": image,
        "giftNum": giftNum,
        "extraName": extraName,
        "createTime": createTime,
      };
}
