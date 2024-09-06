class PurseLogList {
  PurseLogList({
    required this.optType,
    required this.logType,
    required this.amount,
    required this.goldNum,
    required this.remark,
    required this.createTime,
    required this.icon,
    required this.typeName,
  });

  final int optType;
  final int logType;
  final num amount;
  final num goldNum;
  final String remark;
  final int createTime;
  final String icon;
  final String typeName;

  factory PurseLogList.fromJson(Map<String, dynamic> json) {
    return PurseLogList(
      optType: json["optType"] ?? 0,
      logType: json["logType"] ?? 0,
      amount: json["amount"] ?? 0,
      goldNum: json["goldNum"] ?? 0,
      remark: json["remark"] ?? "",
      createTime: json["createTime"] ?? 0,
      icon: json["icon"] ?? "",
      typeName: json["typeName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "optType": optType,
        "logType": logType,
        "amount": amount,
        "goldNum": goldNum,
        "remark": remark,
        "createTime": createTime,
        "icon": icon,
        "typeName": typeName,
      };
}
