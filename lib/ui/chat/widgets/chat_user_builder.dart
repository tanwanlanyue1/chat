import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户信息builder

class ChatUserBuilder extends StatefulWidget {

  ///用户ID
  final String userId;

  ///默认用户信息(加载中或者失败时显示)
  final ZIMUserFullInfo? defaultInfo;

  final Widget Function(ZIMUserFullInfo? userInfo) builder;

  const ChatUserBuilder({
    super.key,
    required this.userId,
    this.defaultInfo,
    required this.builder,
  });

  @override
  State<ChatUserBuilder> createState() => _ChatUserBuilderState();
}

class _ChatUserBuilderState extends State<ChatUserBuilder> with AutoDisposeMixin {

  ZIMUserFullInfo? info;
  @override
  void initState() {
    super.initState();
    info = ChatUserInfoCache().get(widget.userId);
    if(info == null){
      ChatUserInfoCache().getOrQuery(widget.userId).then((value){
        setState(() {
          info = value;
        });
      });
    }
    autoCancel(ChatUserInfoCache().userInfoStream.listen((event) {
      if(event.baseInfo.userID == widget.userId){
        setState(() {
          info = event;
        });
      }
    }));
  }

  @override
  void didUpdateWidget(covariant ChatUserBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.userId != widget.userId){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = this.info ?? widget.defaultInfo;
    if(info != null){
      return widget.builder.call(info);
    }else{
      return Spacing.blank;
    }
  }
}
