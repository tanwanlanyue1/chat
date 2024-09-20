class MessageUnreadModel {
  MessageUnreadModel({
    required this.systemCount,
    required this.userCount,
    required this.title,
    required this.content,
    required this.type,
    required this.id,
    required this.time,
  });

  ///未读消息总数
  int get total => systemCount + userCount;

  ///未读公告消息总数
  final int systemCount;

  ///未读个人消息总数
  final int userCount;

  ///	最新消息标题
  final String title;

  ///	最新消息内容
  final String content;

  /// 最新消息类型 1系统公告 2个人通知
  final int type;

  ///消息ID
  final int id;

  ///消息发送时间
  final int time;

  factory MessageUnreadModel.fromJson(Map<String, dynamic> json){
    return MessageUnreadModel(
      systemCount: json["systemCount"] ?? 0,
      userCount: json["userCount"] ?? 0,
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      type: json["type"] ?? 0,
      id: json["id"] ?? 0,
      time: json["time"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "systemCount": systemCount,
    "userCount": userCount,
    "title": title,
    "content": content,
    "type": type,
    "id": id,
    "time": time,
  };

  MessageUnreadModel copyWith({
    int? systemCount,
    int? userCount,
    String? content,
    String? title,
    int? type,
    int? id,
    int? time,
  }) {
    return MessageUnreadModel(
      systemCount: systemCount ?? this.systemCount,
      userCount: userCount ?? this.userCount,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      id: id ?? this.id,
      time: time ?? this.time,
    );
  }

}
