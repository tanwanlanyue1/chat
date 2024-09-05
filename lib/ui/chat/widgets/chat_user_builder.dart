import 'package:flutter/material.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
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
    final info = ChatUserInfoCache().get(userId);
    if(info != null){
      return builder.call(info);
    }
    return  FutureBuilder(
      future: ChatUserInfoCache().getOrQuery(userId),
      builder: (context, snapshot) {
        return builder.call(snapshot.data);
      },
    );
  }
}
