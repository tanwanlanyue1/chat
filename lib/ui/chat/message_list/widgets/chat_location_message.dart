import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_unknown_message.dart';

///位置消息
class ChatLocationMessage extends StatelessWidget {
  const ChatLocationMessage({
    super.key,
    required this.message,
    this.onPressed,
    this.onLongPress,
  });

  final ZIMKitMessage message;
  final void Function(
          BuildContext context, ZIMKitMessage message, Function defaultAction)?
      onPressed;
  final void Function(BuildContext context, LongPressStartDetails details,
      ZIMKitMessage message, Function defaultAction)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final content = message.locationContent;
    if (content == null) {
      return ChatUnknownMessage(message: message);
    }

    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {
          Get.toNamed(AppRoutes.displayLocationPage, arguments: {'content': content});
        }),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: Container(
          width: 287.rpx,
          padding: FEdgeInsets(all: 10.rpx),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: FEdgeInsets(
                  right: 10.rpx,
                ),
                child: AppImage.asset(
                  'assets/images/chat/chat_location_msg.png',
                  width: 80.rpx,
                  height: 80.rpx,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if(content.poi.isNotEmpty) Text(
                      content.poi,
                      style: AppTextStyle.fs16.copyWith(
                        color: AppColor.blackBlue,
                        height: 1.4,
                      ),
                    ),
                    if(content.address.isNotEmpty) Text(
                      content.address,
                      style: AppTextStyle.fs12.copyWith(
                        color: AppColor.grayText,
                        height: 1.4,
                      ),
                    ),
                  ].separated(Spacing.h(2)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
