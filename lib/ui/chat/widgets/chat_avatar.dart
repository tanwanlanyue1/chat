import 'package:flutter/material.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///聊天用户头像
class ChatAvatar extends StatelessWidget {
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
    required double width,
    required double height,
  }) {
    return ChatAvatar(
      key: key,
      userId: userId,
      width: width,
      height: height,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = ChatUserInfoCache().get(userId);
    Widget child;
    if(info != null){
      child = SizedBox(
        width: width,
        height: height,
        child: info.icon,
      );
    }else{
      child = FutureBuilder(
        future: ChatUserInfoCache().getOrQuery(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: width,
              height: height,
              child: (snapshot.data!).icon,
            );
          } else {
            return AppImage.asset(
              'assets/images/common/default_avatar.png',
              width: width,
              height: height,
            );
          }
        },
      );
    }

    if (shape == BoxShape.rectangle && borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    if (shape == BoxShape.circle) {
      return ClipOval(child: child);
    }
    return child;
  }
}
