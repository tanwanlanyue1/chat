import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/user_style.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_unknown_message.dart';

///用户信息卡片
class ChatUserCardMessage extends StatelessWidget {
  const ChatUserCardMessage({
    super.key,
    required this.message,
    this.onPressed,
    this.onLongPress,
  });

  final ZIMKitMessage message;
  final void Function(
    BuildContext context,
    ZIMKitMessage message,
    Function defaultAction,
  )? onPressed;

  final void Function(
    BuildContext context,
    LongPressStartDetails details,
    ZIMKitMessage message,
    Function defaultAction,
  )? onLongPress;

  @override
  Widget build(BuildContext context) {
    final userInfo = message.userCardContent;
    if (userInfo == null) {
      return ChatUnknownMessage(message: message);
    }

    Widget child = Container(
      margin: FEdgeInsets(top: 12.rpx),
      padding: FEdgeInsets(all: 12.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.rpx),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          buildBaseInfo(userInfo),
          buildTags(userInfo),
          if(userInfo.images?.isNotEmpty == true || userInfo.signature?.isNotEmpty == true) buildAboutTa(userInfo),
        ].separated(Spacing.h12).toList(),
      ),
    );

    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {
          Get.toNamed(AppRoutes.userCenterPage, arguments: {
            'userId': userInfo.uid,
          });
        }),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: child,
      ),
    );
  }

  ///基本信息
  Widget buildBaseInfo(UserModel userInfo) {
    final age = userInfo.age ?? 0;
    final gender = userInfo.gender;
    final position = userInfo.position ?? '';

    return buildItem(
      icon: 'assets/images/chat/ic_base_info.png',
      label: '信息：',
      children: [
        //性别年龄
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.rpx, vertical: 5.rpx),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: gender.iconColor.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage.asset(gender.icon, size: 8.rpx),
              if (age > 0)
                Text(
                  " $age",
                  style: AppTextStyle.fs10.copyWith(
                    color: gender.iconColor,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        ),
        //地址
        if (position.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.rpx, vertical: 5.rpx),
            margin: FEdgeInsets(left: 4.rpx),
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: AppColor.primaryBlue.withOpacity(0.1),
            ),
            constraints: BoxConstraints(maxWidth: 200.rpx),
            child: Text(
              position,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.fs10.copyWith(
                color: AppColor.primaryBlue,
                height: 1.0,
              ),
            ),
          ),
      ],
    );
  }

  ///标签
  Widget buildTags(UserModel userInfo) {
    return buildItem(
      icon: 'assets/images/chat/ic_user_tags.png',
      label: '标签：',
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 200.rpx),
          height: 20.rpx,
          child: UserStyle(styleList: userInfo.styleList),
        ),
      ],
    );
  }

  ///关于TA
  Widget buildAboutTa(UserModel userInfo) {
    var images = userInfo.images ?? '';
    if (images.isEmpty) {
      return Spacing.blank;
    }
    final urls = <String>[];
    try {
      final json = jsonDecode(images);
      if (json is List) {
        urls.addAll(json.map((e) => e.toString()));
      }
    } catch (ex) {
      AppLogger.d(ex);
    }
    if (urls.isEmpty) {
      return Spacing.blank;
    }

    final signature = userInfo.signature ?? '';

    return buildItem(
      icon: 'assets/images/chat/ic_about_ta.png',
      label: '关于Ta：',
      crossAxisAlignment: (signature.isNotEmpty && urls.isNotEmpty) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(urls.isNotEmpty) Row(
              children: urls
                  .take(3)
                  .map<Widget>((item) {
                return AppImage.network(
                  item,
                  width: 40.rpx,
                  height: 40.rpx,
                  borderRadius: BorderRadius.circular(4.rpx),
                );
              })
                  .separated(Spacing.w(6))
                  .toList(),
            ),
            if(signature.isNotEmpty) Container(
              padding: FEdgeInsets(top: urls.isNotEmpty ? 8.rpx : 0),
              constraints: BoxConstraints(maxWidth: 230.rpx),
              child: Text(signature, style: const TextStyle(height: 1.3)),
            ),
          ],
        )
      ],
    );
  }


  Widget buildItem({
    String? icon,
    required String label,
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return DefaultTextStyle(
      style: AppTextStyle.fs10.copyWith(
        color: AppColor.black999,
        height: 1.0,
      ),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          SizedBox(
            width: 16.rpx,
            height: 16.rpx,
            child: icon == null ? null : Image.asset(icon),
          ),
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              label,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black3,
                height: 1.0,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
