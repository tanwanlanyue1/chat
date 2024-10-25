import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class OrderOperationNumberWidget extends StatelessWidget {
  const OrderOperationNumberWidget({
    super.key,
    required this.number,
    required this.title,
    this.icon,
    this.numberColor,
    this.titleColor,
    this.backgroundColor,
    this.borderRadius,
  });

  final int number;
  final String? icon;
  final String title;
  final Color? numberColor;
  final Color? titleColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: FEdgeInsets(right: 6.rpx),
                  child: AppImage.asset(icon!, width: 24.rpx, height: 24.rpx),
                ),
              Text(
                number.toString(),
                style: AppTextStyle.st.bold
                    .size(16.rpx)
                    .textColor(numberColor ?? AppColor.blackBlue),
              ),
            ],
          ),
          SizedBox(height: icon != null ? 2.rpx : 4.rpx),
          Text(
            title,
            style: AppTextStyle.st
                .size(12.rpx)
                .textColor(titleColor ?? AppColor.black6),
          ),
        ],
      ),
    );
  }
}
