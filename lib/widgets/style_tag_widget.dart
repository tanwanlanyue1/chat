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
    this.filtrate = false,
    this.onChanged,
  });

  final String icon;
  final String title;
  final bool isSelected;
  final bool filtrate;//筛选
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!isSelected);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: filtrate ? (isSelected
              ? AppColor.primaryBlue
              : Colors.white):
          (isSelected
              ? AppColor.primaryBlue
              : AppColor.black999.withOpacity(0.1)),
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
                style: AppTextStyle.fs12.copyWith(
                  color: isSelected ? Colors.white : AppColor.blackBlue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
