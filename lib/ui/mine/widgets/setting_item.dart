import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      height: autoHeight ? null : 45.rpx,
      padding: EdgeInsets.all(12.rpx),
      margin: EdgeInsets.only(bottom: bottom ?? 10.rpx),
      child: InkWell(
        onTap: () {
          callBack?.call();
        },
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.rpx),
            ),
            SizedBox(width: 8.rpx),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? Container(),
              ),
            ),
            right ??
                AppImage.asset(
                  "assets/images/mine/right.png",
                  width: 20.rpx,
                  height: 20.rpx,
                ),
          ],
        ),
      ),
    );
  }
}
