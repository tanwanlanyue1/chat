///音视频速配消息内容
class MessageCallMatchContent {

  final String message;

  MessageCallMatchContent({
    required this.message,
  });

  factory MessageCallMatchContent.fromJson(Map<String, dynamic> json) {
    return MessageCallMatchContent(
      message: json['message'] ?? '',
    );
  }
}
