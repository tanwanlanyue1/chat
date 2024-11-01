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

  final bool? badge;
  final VoidCallback? onTap;

  const MineListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.pagePath,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: 52.rpx,
      padding: FEdgeInsets(left: 16.rpx, right: 12.rpx),
      child: Row(
        children: [
          Badge(
            backgroundColor: AppColor.red6,
            isLabelVisible: (badge ?? false),
            child: AppImage.asset(
              icon,
              width: 24.rpx,
              height: 24.rpx,
            ),
          ),
          Spacing.w8,
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.blackText,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.black999,
              ),
            ),
          // if (onTap != null)
          Icon(
            Icons.keyboard_arrow_right,
            size: 24.rpx,
            color: const Color(0xFFC5C6CB),
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
