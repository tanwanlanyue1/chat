import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'app_image.dart';
import 'edge_insets.dart';
import 'spacing.dart';

class SettingSectionTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final Widget? child;
  final bool isEnabled;

  const SettingSectionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.borderRadius,
    this.padding,
    this.selected = false,
    this.onChanged,
    this.onTap,
    this.child,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    assert(!(onChanged != null && onTap != null), '不能同时设置 onChanged和onTap');

    Widget widget = DefaultTextStyle(
      style: AppTextStyle.fs14.copyWith(
        height: 21 / 15,
        color: AppColor.gray5,
      ),
      child: title,
    );
    if (subtitle != null) {
      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget,
          DefaultTextStyle(
            style: AppTextStyle.fs12.copyWith(
              height: 16 / 11,
              color: AppColor.gray9,
            ),
            child:subtitle!,
          )
        ],
      );
    }

    if (onChanged != null || onTap != null || trailing != null || leading != null) {
      widget = Row(
        children: [
          if(leading != null) leading!,
          Expanded(child: widget),
          Spacing.w8,
          if (trailing != null)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14.rpx,
                color: AppColor.gray9,
              ),
              child: trailing!,
            ),
          if (onChanged != null) CupertinoSwitch(value: selected, onChanged: isEnabled ? onChanged : null),
          if (onTap != null)
            AppImage.asset(
              'assets/images/common/ic_arrow_right_black.png',
              width: 20.rpx,
              height: 20.rpx,
            ),
        ],
      );

      if (onTap != null && isEnabled) {
        widget = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: widget,
        );
      }
    }

    widget = Container(
      alignment: Alignment.centerLeft,
      constraints: BoxConstraints(minHeight: 45.rpx),
      padding: padding ?? FEdgeInsets(horizontal: 12.rpx, vertical: 8.rpx),
      child: widget,
    );

    if (child != null) {
      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget,
          const Divider(height: 0),
          child!,
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8.rpx),
      ),
      child: widget,
    );
  }
}
