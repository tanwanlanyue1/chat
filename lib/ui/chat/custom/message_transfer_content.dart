import 'dart:convert';

///转账消息内容
class MessageTransferContent {

  ///转账金额
  final num amount;

  ///转账时间
  final int time;

  MessageTransferContent({
    required this.amount,
    required this.time,
  });

  factory MessageTransferContent.fromJson(Map<String, dynamic> json){
    return MessageTransferContent(
      amount: json['amount'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'time': time,
    };
  }

  String toJsonString() => jsonEncode(toJson());

}
