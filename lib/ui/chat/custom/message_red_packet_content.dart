import 'dart:convert';

///红包消息内容
class MessageRedPacketContent {

  ///转账金额
  final String amount;

  ///描述文本
  final String desc;

  ///状态 0未领取，1已领取，2接收方已退回红包，3发送方撤回红包，4已过期
  final int status;

  MessageRedPacketContent({
    required this.amount,
    required this.desc,
    required this.status,
  });

  factory MessageRedPacketContent.fromJson(Map<String, dynamic> json){
    return MessageRedPacketContent(
      amount: json['amount'],
      desc: json['desc'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'desc': desc,
      'status': status,
    };
  }

  String toJsonString() => jsonEncode(toJson());

}
