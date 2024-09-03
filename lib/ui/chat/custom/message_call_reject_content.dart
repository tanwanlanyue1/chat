import 'dart:convert';

///通话邀请被拒绝消息内容
class MessageCallRejectContent {
  ///是否是视频通话
  final bool isVideoCall;

  final String message;

  MessageCallRejectContent({
    required this.isVideoCall,
    required this.message,
  });

  factory MessageCallRejectContent.fromJson(Map<String, dynamic> json) {
    return MessageCallRejectContent(
      isVideoCall: json['isVideoCall'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'isVideoCall': isVideoCall,
      'message': message,
    };
  }

  String toJsonString(){
    return jsonEncode(toJson());
  }
}
