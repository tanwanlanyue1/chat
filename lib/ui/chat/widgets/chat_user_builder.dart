import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户信息builder
class ChatUserBuilder extends StatelessWidget {
  final String userId;
  final Widget Function(ZIMUserFullInfo? userInfo) builder;

  const ChatUserBuilder({
    super.key,
    required this.userId,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: ZIMKit().queryUser(userId),
      builder: (context, snapshot) {
        return builder.call(snapshot.data);
      },
    );
  }
}
