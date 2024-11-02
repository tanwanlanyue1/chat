import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/message_dating_content.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import '../../../../widgets/app_image.dart';
import 'chat_unknown_message.dart';

///征友约会消息
class ChatDatingMessage extends StatelessWidget {
  const ChatDatingMessage({
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
    final content = message.datingContent;
    if (content == null) {
      return ChatUnknownMessage(message: message);
    }

    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {
          final orderId = content.orderId;
          if(orderId > 0){
            Get.toNamed(AppRoutes.orderDetailPage, arguments: {
              "orderId": orderId,
            });
          }
        }),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: 220.rpx,
              ),
              padding: FEdgeInsets(all: 12.rpx),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.rpx),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildType(content.type),
                  buildDate(content),
                  buildSubType(content),
                  buildAvatars(content),
                ],
              ),
            ),
            Positioned(
              top: 16.rpx,
              right: 12.rpx,
              child: Text(
                S.current.dating,
                style: AppTextStyle.fs10.copyWith(
                  color: AppColor.grayText,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildType(String type) {
    return Container(
      height: 20.rpx,
      padding: FEdgeInsets(horizontal: 8.rpx, vertical: 5.rpx),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.rpx),
          gradient: LinearGradient(
            colors: AppColor.horizontalGradient.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(1.rpx, 0),
              blurRadius: 3.rpx,
              color: const Color(0xFF8BD8FF).withOpacity(0.8),
              inset: true,
            ),
            BoxShadow(
              offset: Offset(-1.rpx, 0),
              blurRadius: 3.rpx,
              color: const Color(0xFFE19AFF).withOpacity(0.8),
              inset: true,
            ),
          ]),
      child: Text(
        type,
        style: AppTextStyle.fs10m.copyWith(
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }

  Widget buildDate(MessageDatingContent content) {
    final startTime = content.startTime.dateTime.toFormat('MM/dd HH:mm');
    final endTime = content.endTime.dateTime.toFormat('MM/dd HH:mm');
    return Padding(
      padding: FEdgeInsets(top: 8.rpx),
      child: Text(
        '时间：$startTime - $endTime',
        style: AppTextStyle.fs10.copyWith(
          color: AppColor.black6,
          height: 1,
        ),
      ),
    );
  }

  Widget buildSubType(MessageDatingContent content) {
    final images = content.subType
        .split(',')
        .where((element) => element.startsWith('http'));
    if (images.isEmpty) {
      return Spacing.blank;
    }
    return Padding(
      padding: FEdgeInsets(top: 8.rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: images.mapIndexed((index, item) {
          return Padding(
            padding: FEdgeInsets(left: index == 0 ? 0 : 4.rpx),
            child: CachedNetworkImage(
              imageUrl: item,
              height: 20.rpx,
            ),
          );
        }).toList(growable: false),
      ),
    );
  }

  Widget buildAvatars(MessageDatingContent content) {
    final isFromSelf = content.fromUid == SS.login.userId;
    return Padding(
      padding: FEdgeInsets(top: 8.rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: -8.rpx,
            children: isFromSelf
                ? [buildSelfAvatar(), buildUserAvatar()]
                : [buildUserAvatar(), buildSelfAvatar()],
          ),
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              isFromSelf ? '对方已同意参与' : '我已同意参与',
              style: AppTextStyle.fs12.copyWith(
                color: AppColor.blackBlue,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSelfAvatar() {
    return Container(
      padding: const FEdgeInsets(all: 1),
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white,
      ),
      child: AppImage.network(
        SS.login.info?.avatar ?? '',
        width: 24.rpx,
        height: 24.rpx,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildUserAvatar() {
    return Container(
      padding: const FEdgeInsets(all: 1),
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white,
      ),
      child: ChatAvatar.circle(
        userId: message.info.conversationID,
        size: 24.rpx,
      ),
    );
  }
}
