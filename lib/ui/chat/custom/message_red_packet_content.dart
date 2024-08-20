import 'dart:convert';

///红包消息内容
class MessageRedPacketContent {

  ///转账金额
  final String amount;

  ///描述文本
  final String desc;

  ///状态 0未领取，1已领取，2接收方已退回红包，3发送方撤回红包，4已过期
  final int status;

  ///过期时间
  final int expiredTime;

  ///红包发送方
  final int fromUid;

  ///红包接收方
  final int toUid;

  MessageRedPacketContent({
    required this.amount,
    required this.desc,
    required this.status,
    required this.expiredTime,
    required this.fromUid,
    required this.toUid,
  });

  factory MessageRedPacketContent.fromJson(Map<String, dynamic> json){
    return MessageRedPacketContent(
      amount: json['amount'],
      desc: json['desc'],
      status: json['status'],
      expiredTime: json['expiredTime'],
      fromUid: json['fromUid'],
      toUid: json['toUid'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'desc': desc,
      'status': status,
      'expiredTime': expiredTime,
      'fromUid': fromUid,
      'toUid': toUid,
    };
  }

  String toJsonString() => jsonEncode(toJson());

}
