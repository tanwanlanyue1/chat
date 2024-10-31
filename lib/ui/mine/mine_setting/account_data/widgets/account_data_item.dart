import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///设置项
class AccountDataItem extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final String? detail;
  final String? detailHintText;
  final Widget? trailing;
  final double? height;
  final bool autoHeight;

  const AccountDataItem({
    super.key,
    this.onTap,
    this.title,
    this.detail,
    this.detailHintText,
    this.trailing,
    this.height,
    this.autoHeight = false,
  });

  @override
  Widget build(BuildContext context) {

    detailWidget() {
      final text = detail ?? detailHintText ?? "";
      return Text(
        text,
        style: detail == null
            ? AppTextStyle.fs14.copyWith(color: AppColor.black9)
            : AppTextStyle.fs14.copyWith(
                color: AppColor.blackBlue,
              ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
      height: autoHeight ? null : height ?? 52.rpx,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
        border: Border.all(color: AppColor.black9.withOpacity(0.2)),
      ),
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Text(
              title ?? "",
              style: AppTextStyle.fs14.textColor(AppColor.tab),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? detailWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
