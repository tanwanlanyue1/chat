import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class MineListTile extends StatelessWidget {
  final String icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const MineListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: 56.rpx,
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Row(
        children: [
          AppImage.asset(
            icon,
            width: 24.rpx,
            height: 24.rpx,
          ),
          Spacing.w8,
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.gray9,
              ),
            ),
          if (onTap != null)
            Icon(
              Icons.keyboard_arrow_right,
              size: 16.rpx,
              color: AppColor.gray9,
            )
        ],
      ),
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
}
