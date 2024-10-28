///征友约会消息内容
class MessageDatingContent {

  /// 约会类型
  final String type;

  /// 附加标签
  final String subType;

  /// 开始时间
  final int startTime;

  /// 结束时间
  final int endTime;

  /// 发起人id
  final int fromUid;

  /// 参与人ID
  final int joinUid;

  /// 参与人头像
  final String joinAvatar;

  MessageDatingContent({
    required this.type,
    required this.subType,
    required this.startTime,
    required this.endTime,
    required this.fromUid,
    required this.joinUid,
    required this.joinAvatar,
  });

  factory MessageDatingContent.fromJson(Map<String, dynamic> json) {
    return MessageDatingContent(
      type: json['type'] ?? 0,
      subType: json['subType'] ?? '',
      startTime: json['startTime'] ?? 0,
      endTime: json['endTime'] ?? 0,
      fromUid: json['fromUid'] ?? 0,
      joinUid: json['joinUid'] ?? 0,
      joinAvatar: json['joinAvatar'] ?? '',
    );
  }

  @override
  String toString() {
    return '{type: $type, subType: $subType, startTime: $startTime, endTime: $endTime, fromUid: $fromUid, joinUid: $joinUid, joinAvatar: $joinAvatar}';
  }
}
