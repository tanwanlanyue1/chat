///通话结束消息内容
class MessageCallEndContent {
  ///是否是视频通话
  final bool isVideoCall;

  ///开始时间
  final int beginTime;

  ///结束时间
  final int endTime;

  ///通话时长(s)
  final int duration;

  ///发起方
  final int inviter;

  ///接收方
  final int invitee;

  ///用户付费金额
  final num amount;

  ///平台分成百分百0-100
  final num platformRate;

  ///平台费用
  final num platformFee;

  ///佳丽分成百分百0-100
  final num beautyRate;

  ///佳丽收益
  final num beautyFee;

  ///经纪人分成百分百0-100，佳丽有经纪人的情况下才会返回
  final num? agentRate;

  ///经纪人收益,佳丽有经纪人的情况下才会返回
  final num? agentFee;

  ///佳丽是否有经纪人
  bool get hasAgent => agentRate != null && agentFee != null;

  MessageCallEndContent({
    required this.isVideoCall,
    required this.beginTime,
    required this.endTime,
    required this.duration,
    required this.inviter,
    required this.invitee,
    required this.amount,
    required this.platformRate,
    required this.platformFee,
    required this.beautyRate,
    required this.beautyFee,
    required this.agentRate,
    required this.agentFee,
  });

  factory MessageCallEndContent.fromJson(Map<String, dynamic> json) {
    return MessageCallEndContent(
      isVideoCall: json['isVideoCall'] ?? false,
      beginTime: json['beginTime'] ?? 0,
      endTime: json['endTime'] ?? 0,
      duration: json['duration'] ?? 0,
      inviter: json['inviter'] ?? 0,
      invitee: json['invitee'] ?? 0,
      amount: json['amount'] ?? 0,
      platformFee: json['platformFee'] ?? 0,
      platformRate: json['platformRate'] ?? 0,
      beautyFee: json['beautyFee'] ?? 0,
      beautyRate: json['beautyRate'] ?? 0,
      agentFee: json['agentFee'],
      agentRate: json['agentRate'],
    );
  }
}
