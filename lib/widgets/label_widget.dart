import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

/// LabelItem 类型定义，用于存储标签的标题和选择状态
class LabelItem {
  final int id;
  final String title;
  bool selected;

  LabelItem({
    required this.id,
    required this.title,
    this.selected = false,
  });
}

/// 标签组件
class LabelWidget extends StatelessWidget {
  const LabelWidget({
    super.key,
    required this.item,
    this.onTap,
    this.height,
    this.borderRadius,
    this.fontWeight,
    this.textColor,
    this.selectedTextColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
  });

  final LabelItem item;
  final Function? onTap;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        height: height ?? 46.rpx,
        padding: EdgeInsets.symmetric(
          horizontal: 24.rpx,
        ),
        decoration: BoxDecoration(
          color: item.selected
              ? selectedBackgroundColor ?? Colors.white
              : backgroundColor,
          border: Border.all(
            color: borderColor ?? Colors.white,
            width: 1.rpx,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(8.rpx),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              style: AppTextStyle.fs14b
                  .textColor(item.selected
                      ? selectedTextColor ?? AppColor.black3
                      : textColor ?? Colors.white)
                  .copyWith(
                    fontWeight: fontWeight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
