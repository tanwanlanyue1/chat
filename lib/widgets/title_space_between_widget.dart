import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class TitleSpaceBetweenWidget extends StatelessWidget {
  const TitleSpaceBetweenWidget({
    super.key,
    this.title,
    this.detail,
    this.titleStyle,
    this.detailStyle,
    this.titleColor,
    this.detailColor,
    this.titleSize,
    this.detailSize,
    this.detailLeading,
    this.padding,
    this.height,
  });

  final String? title;
  final String? detail;
  final Color? titleColor;
  final Color? detailColor;
  final double? titleSize;
  final double? detailSize;
  final TextStyle? titleStyle;
  final TextStyle? detailStyle;
  final Widget? detailLeading;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "",
            style: titleStyle ??
                AppTextStyle.st.medium
                    .size(titleSize ?? 14.rpx)
                    .textColor(titleColor ?? AppColor.black3),
            maxLines: 1,
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                detailLeading ?? const SizedBox(),
                Flexible(
                  child: Text(
                    detail ?? "",
                    style: detailStyle ??
                        AppTextStyle.st
                            .size(detailSize ?? 14.rpx)
                            .textColor(detailColor ?? AppColor.black9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
