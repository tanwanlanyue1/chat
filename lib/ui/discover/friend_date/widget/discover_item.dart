import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///邀约项
class DiscoverItem extends StatelessWidget {
  final String title;
  final double? bottom;
  final Function? callBack;
  final Widget? trailing;
  final Widget? right;
  final BorderRadiusGeometry? borderRadius;
  final bool autoHeight;
  final bool location;
  const DiscoverItem({
    super.key,
    required this.title,
    this.bottom,
    this.callBack,
    this.trailing,
    this.right,
    this.borderRadius,
    this.autoHeight = false,
    this.location = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.rpx)),
      height: autoHeight ? null : 54.rpx,
      padding: EdgeInsets.all(12.rpx),
      margin: EdgeInsets.only(bottom: bottom ?? 8.rpx),
      child: InkWell(
        onTap: () {
          callBack?.call();
        },
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.rpx,color: AppColor.black92),
            ),
            SizedBox(width: 4.rpx),
            Visibility(
              visible: location,
              child: AppImage.asset(
                "assets/images/discover/location.png",
                width: 16.rpx,
                height: 16.rpx,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? Container(),
              ),
            ),
            SizedBox(width: 2.rpx),
            right ??
                AppImage.asset(
                  "assets/images/discover/discover_right.png",
                  width: 16.rpx,
                  height: 16.rpx,
                ),
          ],
        ),
      ),
    );
  }
}
