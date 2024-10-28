import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///设置项
class SettingItem extends StatelessWidget {
  final String title;
  final double? bottom;
  final Function? callBack;
  final Widget? trailing;
  final Widget? right;
  final BorderRadiusGeometry? borderRadius;
  final bool autoHeight;
  const SettingItem({
    super.key,
    required this.title,
    this.bottom,
    this.callBack,
    this.trailing,
    this.right,
    this.borderRadius,
    this.autoHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.rpx)),
      height: autoHeight ? null : 56.rpx,
      padding: EdgeInsets.all(12.rpx),
      margin: EdgeInsets.only(bottom: bottom ?? 12.rpx),
      child: InkWell(
        onTap: () {
          callBack?.call();
        },
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyle.fs14m.copyWith(color: AppColor.black3),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? Container(),
              ),
            ),
            SizedBox(width: 8.rpx),
            right ??
                AppImage.asset(
                  "assets/images/mine/mine_right.png",
                  width: 16.rpx,
                  height: 16.rpx,
                ),
          ],
        ),
      ),
    );
  }
}
