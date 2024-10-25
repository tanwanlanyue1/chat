import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'edge_insets.dart';

///未读数
class UnreadBadge extends StatelessWidget {
  final int unread;

  const UnreadBadge({super.key, required this.unread});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.rpx,
      constraints: BoxConstraints(minWidth: 16.rpx),
      padding: FEdgeInsets(horizontal: 4.rpx),
      alignment: Alignment.center,
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.red6,
      ),
      child: Text(
        unread.toUnreadBadge(),
        style: AppTextStyle.fs10r.copyWith(
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }
}

class TabUnreadBadge extends StatelessWidget {
  final int unread;
  final bool isUnreadVisible;
  final Widget child;
  final Offset offset;

  const TabUnreadBadge({
    super.key,
    required this.child,
    required this.unread,
    this.isUnreadVisible = true,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    if(!isUnreadVisible){
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        child,
        Positioned(
          top: offset.dy,
          left: offset.dx,
          child: UnreadBadge(unread: unread),
        )
      ],
    );
  }
}
