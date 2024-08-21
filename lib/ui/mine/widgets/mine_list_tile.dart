import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class MineListTile extends StatelessWidget {
  ///图标
  final String icon;

  ///标题
  final String title;

  ///尾部文本
  final String? trailing;

  ///跳转页面
  final String? pagePath;
  final VoidCallback? onTap;

  const MineListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.pagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: 56.rpx,
      padding: FEdgeInsets(left: 16.rpx, right: 12.rpx),
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
              style: AppTextStyle.fs14b.copyWith(
                color: AppColor.black4E,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTextStyle.fs12b.copyWith(
                color: AppColor.gray9,
              ),
            ),
          // if (onTap != null)
          Icon(
            Icons.keyboard_arrow_right,
            size: 24.rpx,
            color: AppColor.gray9,
          )
        ],
      ),
    );
    return GestureDetector(
      onTap: (){
        if(pagePath != null){
          Get.toNamed(pagePath!);
        }
        onTap?.call();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
