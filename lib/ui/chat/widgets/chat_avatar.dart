import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/model/im/chat_user_model.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户头像
class ChatAvatar extends StatefulWidget {
  final String userId;
  final BorderRadius? borderRadius;
  final double width;
  final double height;
  final BoxShape shape;

  const ChatAvatar({
    super.key,
    required this.userId,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  factory ChatAvatar.circle({
    Key? key,
    required String userId,
    required double size,
  }) {
    return ChatAvatar(
      key: key,
      userId: userId,
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  @override
  State<ChatAvatar> createState() => _ChatAvatarState();
}

class _ChatAvatarState extends State<ChatAvatar> with AutoDisposeMixin {

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
    autoCancel(ChatUserManager().stream.listen((event) {
      if(event.containsKey(widget.userId)){
        setState(() {
          info = event[widget.userId];
        });
      }
    }));
  }

  @override
  void didUpdateWidget(covariant ChatAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.userId != widget.userId){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = AppImage.asset(
      'assets/images/common/default_avatar.png',
      width: widget.width,
      height: widget.height,
    );
    Widget child;
    final info = this.info;
    if(info != null){
      child = AppImage.network(
        info.avatar,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        placeholder: placeholder,
      );
    }else{
      child = placeholder;
    }

    if (widget.shape == BoxShape.rectangle && widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    if (widget.shape == BoxShape.circle) {
      return ClipOval(child: child);
    }
    return child;
  }
}
