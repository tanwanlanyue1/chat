
import 'dart:convert';

import 'package:guanjia/common/utils/app_logger.dart';

///系统站内消息内容
class MessageSysNoticeContent {

  ///标题
  final String title;

  ///内容
  final String content;

  ///类型(0全部人接收 1指定人接收)
  final int type;

  MessageSysNoticeContent({
    required this.title,
    required this.content,
    required this.type,
  });

  factory MessageSysNoticeContent.fromJson(Map<String, dynamic> json){
    return MessageSysNoticeContent(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'content': content,
      'type': type,
    };
  }

  String toJsonString(){
    return jsonEncode(toJson());
  }

}
