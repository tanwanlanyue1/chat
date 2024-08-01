import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///设置项
class AccountDataItem extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final Widget? trailing;
  final double? height;
  final bool autoHeight;

  const AccountDataItem({
    super.key,
    this.onTap,
    this.title,
    this.trailing,
    this.height,
    this.autoHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
      height: autoHeight ? null : height ?? 60.rpx,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        border: Border.all(color: AppColor.black9.withOpacity(0.2)),
      ),
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Row(
          children: [
            Text(
              title ?? "",
              style: AppTextStyle.st.medium
                  .size(14.rpx)
                  .textColor(AppColor.black3),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
