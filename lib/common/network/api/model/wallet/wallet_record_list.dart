class WalletRecordListRes {
  WalletRecordListRes({
    required this.amount,
    required this.list,
  });

  final int amount;
  final List<WalletRecordRes> list;

  factory WalletRecordListRes.fromJson(Map<String, dynamic> json) {
    return WalletRecordListRes(
      amount: json["amount"] ?? 0,
      list: json["list"] == null
          ? []
          : List<WalletRecordRes>.from(
              json["list"]!.map((x) => WalletRecordRes.fromJson(x))),
    );
  }
}

class WalletRecordRes {
  WalletRecordRes({
    required this.id,
    required this.optType,
    required this.logType,
    required this.rechargeAmount,
    required this.amount,
    required this.goldNum,
    required this.remark,
    required this.extraPlain,
    required this.targetId,
    required this.giftId,
    required this.giftNum,
    required this.createTime,
  });

  final int id; // 记录ID
  final int optType; // 操作类型 1 收入（增加），2 支出（减少）

  /// 记录类型: 根据业务定义
  //       11: '上香',
  //       12: '供礼',
  //       13: '河灯',
  //       14: '天灯',
  //       15: '供灯',
  //       16: '购买佛珠样式',
  //       17: '购买佛珠背景',
  //       18: '木鱼',
  //       19: '念珠',
  final int logType;
  final num rechargeAmount; // 充值金额
  final int amount; // 变化金额
  final int goldNum; // 余额
  final String remark; // 备注说明
  final String extraPlain; // 扩展说明
  final int targetId; //	目标ID（记录ID）
  final int giftId; //	礼物ID
  final int giftNum; // 礼物数量
  final String createTime; // 创建时间

  factory WalletRecordRes.fromJson(Map<String, dynamic> json) {
    return WalletRecordRes(
      id: json["id"] ?? 0,
      optType: json["optType"] ?? 0,
      logType: json["logType"] ?? 0,
      rechargeAmount: json["rechargeAmount"] ?? 0,
      amount: json["amount"] ?? 0,
      goldNum: json["goldNum"] ?? 0,
      remark: json["remark"] ?? "",
      extraPlain: json["extraPlain"] ?? "",
      targetId: json["targetId"] ?? 0,
      giftId: json["giftId"] ?? 0,
      giftNum: json["giftNum"] ?? 0,
      createTime: json["createTime"] ?? "",
    );
  }
}
