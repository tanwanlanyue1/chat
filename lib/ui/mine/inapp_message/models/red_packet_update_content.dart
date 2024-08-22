

///红包状态变更 应用内消息内容
class RedPacketUpdateContent {

  ///消息iD
  final int msgId;

  ///红包状态： 0待领取 1已领取 2已撤回 3已过期
  final int status;

  ///红包发送方
  final int fromUid;

  ///红包接收方
  final int toUid;

  ///创建时间
  final int createTime;

  ///领取时间(领取操作的推送才有值)
  final int? receiveTime;

  ///撤回时间(撤回操作的推送才有值)
  final int? expireTime;


  RedPacketUpdateContent({
    required this.msgId,
    required this.status,
    required this.fromUid,
    required this.toUid,
    required this.createTime,
    this.receiveTime,
    this.expireTime,
  });

  factory RedPacketUpdateContent.fromJson(Map<String, dynamic> json){
    return RedPacketUpdateContent(
      msgId: json['msgId'],
      status: json['status'],
      fromUid: json['fromUid'],
      toUid: json['toUid'],
      createTime: json['createTime'],
      receiveTime: json['receiveTime'],
      expireTime: json['expireTime'],
    );
  }

}
