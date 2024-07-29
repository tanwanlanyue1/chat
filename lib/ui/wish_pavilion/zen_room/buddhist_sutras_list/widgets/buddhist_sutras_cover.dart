import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/buddhist_sutras_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///经书封面
class BuddhistSutrasCover extends StatelessWidget {
  ///经书名称
  final String name;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Alignment alignment;
  final BoxFit fit;

  const BuddhistSutrasCover({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.onTap,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final size = Size(100.rpx, 140.rpx);
    Widget child = GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.topRight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
            AppAssetImage('assets/images/wish_pavilion/zen_room/经书封面.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: buildName(),
      ),
    );
    if(width != size.width || height != size.height){
      child = Container(
        alignment: alignment,
        width: width,
        height: height,
        child: FittedBox(
          fit: fit,
          child: child,
        ),
      );
    }
    return child;
  }

  Widget buildName() {
    return Container(
      constraints: BoxConstraints(
        minWidth: 26.rpx,
        minHeight: 63.rpx,
        maxHeight: 103.rpx,
      ),
      margin: FEdgeInsets(right: 22.rpx, top: 17.rpx),
      padding: FEdgeInsets(vertical: 8.rpx, horizontal: 6.rpx),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
              AppAssetImage('assets/images/wish_pavilion/zen_room/经书名背景.png'),
          fit: BoxFit.fill,
          scale: 3,
          centerSlice: Rect.fromLTWH(20 / 3, 40 / 3, 40 / 3, 120 / 3),
        ),
      ),
      child: Wrap(
        runAlignment: WrapAlignment.center,
        direction: Axis.vertical,
        textDirection: TextDirection.rtl,
        runSpacing: 2.rpx,
        children: name.split('').map((element) {
          return Text(
            element,
            style: AppTextStyle.fs13b.copyWith(
              color: AppColor.brown10,
              height: 1.2,
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
