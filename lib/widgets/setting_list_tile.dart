import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'app_image.dart';
import 'edge_insets.dart';

class SettingListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final VoidCallback? onTap;
  final bool selected;
  final ValueChanged<bool>? onChanged;

  SettingListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.decoration,
    EdgeInsetsGeometry? padding,
    this.onTap,
    this.selected = false,
    this.onChanged,
  }) : padding = padding ?? FEdgeInsets(horizontal: 12.rpx, vertical: 12.rpx) {
    assert(!(onChanged != null && onTap != null), '不能同时设置 onChanged和onTap');
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildTitle();
    if (subtitle != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          _buildSubtitle(),
        ],
      );
    }

    child = Row(
      children: [
        Expanded(child: child),
        if (trailing != null) _buildTrailing(),
        if (onChanged != null) Switch(value: selected, onChanged: onChanged),
        if (onTap != null) _buildArrowRightIcon(),
      ],
    );
    child = Container(
      padding: padding,
      alignment: Alignment.centerLeft,
      decoration: decoration,
      constraints:
          BoxConstraints(minHeight: subtitle != null ? 56.rpx : 45.rpx),
      child: child,
    );
    if (onTap != null) {
      child = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: child,
      );
    }
    return child;
  }

  Widget _buildTitle() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 14.rpx,
        color: AppColor.gray5,
      ),
      child: title,
    );
  }

  Widget _buildSubtitle() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 11.rpx,
        color: AppColor.gray9,
      ),
      child: subtitle ?? const Text(''),
    );
  }

  Widget _buildTrailing() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 14.rpx,
        color: AppColor.gray9,
      ),
      child: trailing ?? const Text(''),
    );
  }

  Widget _buildArrowRightIcon() {
    return AppImage.asset(
      'assets/images/common/ic_arrow_right_black.png',
      width: 20.rpx,
      height: 20.rpx,
    );
  }
}
