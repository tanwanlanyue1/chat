import 'dart:convert';

///转账消息内容
class MessageTransferContent {

  ///转账金额
  final num amount;

  ///转账时间
  final int time;

  ///转账发送方
  final int fromUid;

  ///转账接收方
  final int toUid;

  MessageTransferContent({
    required this.amount,
    required this.time,
    required this.fromUid,
    required this.toUid,
  });

  factory MessageTransferContent.fromJson(Map<String, dynamic> json){
    return MessageTransferContent(
      amount: json['amount'] ?? 0,
      time: json['time'] ?? 0,
      fromUid: json['fromUid'] ?? 0,
      toUid: json['toUid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'time': time,
      'fromUid': fromUid,
      'toUid': toUid,
    };
  }

  String toJsonString() => jsonEncode(toJson());

}
