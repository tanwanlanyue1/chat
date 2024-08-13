import 'dart:convert';

///通话结束消息内容
class MessageCallEndContent {

  ///是否是视频通话
  final bool isVideoCall;

  ///开始时间
  final DateTime beginTime;

  ///通话时长
  final Duration duration;

  ///发起方
  final String inviter;

  ///接收方
  final String invitee;

  ///用户付费金额
  final double amount;

  ///平台收取比例
  final double feeRate;

  ///平台费
  double get fee{
    return amount * feeRate;
  }

  ///陪聊收入(用户付费-平台抽成)
  double get income{
    return amount - fee;
  }

  MessageCallEndContent({
    required this.isVideoCall,
    required this.beginTime,
    required this.duration,
    required this.inviter,
    required this.invitee,
    required this.amount,
    required this.feeRate,
  });

  factory MessageCallEndContent.fromJson(Map<String, dynamic> json){
    return MessageCallEndContent(
      isVideoCall: json['isVideoCall'],
      beginTime: DateTime.fromMillisecondsSinceEpoch(json['beginTime']),
      duration: Duration(seconds: json['duration']),
      inviter: json['inviter'],
      invitee: json['invitee'],
      amount: json['amount'],
      feeRate: json['feeRate'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'isVideoCall': isVideoCall,
      'beginTime': beginTime.millisecondsSinceEpoch,
      'duration': duration.inSeconds,
      'inviter': inviter,
      'invitee': invitee,
      'amount': amount,
      'feeRate': feeRate,
    };
  }

  String toJsonString() => jsonEncode(toJson());

}
