import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/model/im/chat_user_model.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/widgets/spacing.dart';

///聊天用户信息builder

class ChatUserBuilder extends StatefulWidget {

  ///用户ID
  final String userId;

  ///默认用户信息(加载中或者失败时显示)
  final ChatUserModel? defaultInfo;

  final Widget Function(ChatUserModel? userInfo) builder;

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

  ChatUserModel? info;
  @override
  void initState() {
    super.initState();
    info = ChatUserManager().get(widget.userId);
    if(info == null){
      ChatUserManager().getOrQuery(widget.userId).then((value){
        setState(() {
          info = value;
        });
      });
    }
    autoCancel(ChatUserManager().stream.listen((data) {
      if(data.containsKey(widget.userId)){
        setState(() {
          info = data[widget.userId];
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
