import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

/// LabelItem 类型定义，用于存储标签的标题和选择状态
class LabelItem {
  final String title;
  bool selected;

  LabelItem({required this.title, this.selected = false});
}

/// 标签组件
class LabelWidget extends StatelessWidget {
  const LabelWidget({
    super.key,
    required this.item,
    this.onTap,
    this.textColor,
    this.selectedTextColor,
    this.selectedBackgroundColor,
    this.borderColor,
  });

  final LabelItem item;
  final Function? onTap;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.rpx, vertical: 16.rpx),
        decoration: BoxDecoration(
          color: item.selected ? selectedBackgroundColor ?? Colors.white : null,
          border: Border.all(
            color: borderColor ?? Colors.white,
            width: 1.rpx,
          ),
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        child: Text(
          item.title,
          style: AppTextStyle.st.semiBold.size(14.rpx).textColor(item.selected
              ? selectedTextColor ?? AppColor.black3
              : textColor ?? Colors.white),
        ),
      ),
    );
  }
}
