import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/edge_insets.dart';

import 'app_image.dart';

/// 风格标签组件
class StyleTagWidget extends StatelessWidget {
  const StyleTagWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    this.unselectedTextColor,
    this.textColor,
    this.unselectedColor,
    this.color,
    this.onChanged,
    this.textStyle,
  });

  ///用于筛选
  factory StyleTagWidget.filtrate({
    required String icon,
    required String title,
    required bool isSelected,
    ValueChanged<bool>? onChanged,
  }) {
    return StyleTagWidget(
      icon: icon,
      title: title,
      isSelected: isSelected,
      onChanged: onChanged,
      color: AppColor.primaryBlue,
      unselectedColor: Colors.white,
      textColor: Colors.white,
      unselectedTextColor: AppColor.blackBlue,
    );
  }

  final String icon;
  final String title;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  final Color? unselectedTextColor;
  final Color? textColor;
  final Color? unselectedColor;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var textStyle = AppTextStyle.fs12.copyWith(
      color: isSelected
          ? (textColor ?? Colors.white)
          : (unselectedTextColor ?? AppColor.blackBlue),
    );
    if(this.textStyle != null){
      textStyle = this.textStyle?.merge(textStyle) ?? textStyle;
    }

    return GestureDetector(
      onTap: () {
        onChanged?.call(!isSelected);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: isSelected
              ? (color ?? AppColor.primaryBlue)
              : (unselectedColor ?? AppColor.black999.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage.network(
              icon,
              width: 20.rpx,
              height: 20.rpx,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: FEdgeInsets(left: 4.rpx),
              child: Text(
                title,
                style: textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
