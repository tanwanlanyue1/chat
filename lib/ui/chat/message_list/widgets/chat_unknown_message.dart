import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///未知消息
class ChatUnknownMessage extends StatelessWidget {
  const ChatUnknownMessage({
    super.key,
    required this.message,
  });
  final ZIMKitMessage message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.rpx,
          vertical: 8.rpx,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.rpx),
          color: Colors.white,
        ),
        child: Text(
          '[未知消息]',
          textAlign: TextAlign.left,
          style: AppTextStyle.fs14m.copyWith(
            color: AppColor.gray5,
            height: 21 / 14,
          ),
        ),
      ),
    );
  }
}
