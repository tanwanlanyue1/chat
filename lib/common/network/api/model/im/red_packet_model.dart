

///红包
class RedPacketModel {
  RedPacketModel({
    required this.id,
    required this.number,
    required this.fromUid,
    required this.toUid,
    required this.state,
    required this.amount,
    required this.message,
    required this.background,
    required this.msgId,
    required this.createTime,
    required this.receiveTime,
    required this.withdrawTime,
    required this.expirationTime,
  });

  final int id;
  final int number;
  final int fromUid;
  final int toUid;
  final int state;
  final num amount;
  final String message;
  final String background;
  final int msgId;

  ///	发红包时间
  final int createTime;

  ///	领取时间
  final int receiveTime;

  ///	撤回时间
  final int withdrawTime;

  ///	到期时间
  final int expirationTime;

  factory RedPacketModel.fromJson(Map<String, dynamic> json){
    return RedPacketModel(
      id: json["id"] ?? 0,
      number: json["number"] ?? 0,
      fromUid: json["fromUid"] ?? 0,
      toUid: json["toUid"] ?? 0,
      state: json["state"] ?? 0,
      amount: json["amount"] ?? 0,
      message: json["message"] ?? "",
      background: json["background"] ?? "",
      msgId: json["msgId"] ?? 0,
      createTime: json["createTime"] ?? 0,
      receiveTime: json["receiveTime"] ?? 0,
      withdrawTime: json["withdrawTime"] ?? 0,
      expirationTime: json["expirationTime"] ?? 0,
    );
  }

}

