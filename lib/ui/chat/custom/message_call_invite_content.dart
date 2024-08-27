///通话发起消息内容
class MessageCallInviteContent {
  ///是否是视频通话
  final bool isVideoCall;

  final String message;

  MessageCallInviteContent({
    required this.isVideoCall,
    required this.message,
  });

  factory MessageCallInviteContent.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('isVideoCall')){
      json['isVideoCall'] = json['code'] == 1;
    }
    return MessageCallInviteContent(
      isVideoCall: json['isVideoCall'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
