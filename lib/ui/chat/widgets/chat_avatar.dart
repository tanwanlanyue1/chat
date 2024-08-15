import 'package:flutter/material.dart';
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
    Widget child = ZIMKitAvatar(
      userID: userId,
      width: width,
      height: height,
    );
    if (shape == BoxShape.rectangle && borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    if (shape == BoxShape.circle) {
      return ClipOval(child: child);
    }
    return child;
  }
}
