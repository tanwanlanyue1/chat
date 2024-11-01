import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/model/user/message_unread_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/unread_badge.dart';
import 'package:guanjia/widgets/widgets.dart';

///聊天会话列表-系统通知
class ConversationNoticeTile extends StatelessWidget {
  static double? _messageContentMaxWidth;

  final MessageUnreadModel model;

  const ConversationNoticeTile({
    super.key,
    required this.model,
  });

  void onTap() {
    Get.toNamed(AppRoutes.mineMessage, arguments: {
      'tabIndex': model.type == 2 ? 1 : 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: FEdgeInsets(horizontal: 16.rpx, vertical: 12.rpx),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameAndTime(),
                  _buildMessageContent(),
                ].separated(Spacing.h(6)).toList(growable: false),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: FEdgeInsets(right: 12.rpx),
      child: SizedBox(
        width: 40.rpx,
        height: 40.rpx,
        child: AppImage.asset('assets/images/chat/ic_sys_notice.png'),
      ),
    );
  }

  Widget _buildNameAndTime() {
    final time = DateTime.fromMillisecondsSinceEpoch(model.time);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            model.title.isNotEmpty ? model.title : S.current.systemNotice,
            maxLines: 1,
            style: AppTextStyle.fs16m.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          ),
        ),
        if(model.time > 0) Padding(
          padding: FEdgeInsets(left: 8.rpx),
          child: Text(
            time.friendlyTime,
            style: AppTextStyle.normal.copyWith(
              fontSize: 11.rpx,
              color: AppColor.grayText,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent() {
    final maxWidth = ConversationNoticeTile._messageContentMaxWidth ??=
        Get.width - (40 + 32 + 24 + 12).rpx;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(
            model.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.normal.copyWith(
              fontSize: 13.rpx,
              color: AppColor.grayText,
              height: 1.1,
            ),
          ),
        ),
        const Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 16.rpx, minHeight: 16.rpx),
          child: model.total > 0 ? UnreadBadge(
            unread: model.total,
            size: 16.rpx,
          ) : null,
        )
      ],
    );

  }
}
