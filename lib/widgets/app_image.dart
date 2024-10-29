import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:guanjia/widgets/widgets.dart';

///图片显示控件
class AppImage extends StatelessWidget {
  final Widget child;

  ///本地图片资源
  AppImage.asset(
    String name, {
    double? size, // 当宽高一致时方便调用，有值时width和height的设置无效
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    double? scale,
    super.key,
  }) : child = Image.asset(
          name,
          width: size ?? width,
          height: size ?? height,
          color: color,
          opacity: opacity,
          fit: fit,
          alignment: alignment,
          scale: scale,
        );

  ///本地图片文件
  AppImage.file(
    File file, {
    double? length, // 当宽高一致时方便调用，有值时width和height的设置无效
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BoxFit fit = BoxFit.fill,
    AlignmentGeometry alignment = Alignment.center,
    super.key,
  }) : child = Image.file(
          file,
          width: length ?? width,
          height: length ?? height,
          color: color,
          opacity: opacity,
          fit: fit,
          alignment: alignment,
        );

  static int? _toInt(double? value, double scale) {
    if (value == null || value == double.infinity) {
      return null;
    }
    return (value * scale).toInt();
  }

  ///网络图片
  AppImage.network(
    String url, {
    double? length, // 当宽高一致时方便调用，有值时width和height的设置无效
    double? width,
    double? height,
    double? memCacheWidth,
    double? memCacheHeight,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    BoxBorder? border,
    BoxShape shape = BoxShape.rectangle,
    List<BoxShadow>? boxShadow,
    bool clearMemoryCacheWhenDispose = false,
    bool resizeImage = true,
    Widget? placeholder,
    Alignment align = Alignment.center,
    double opacity = 1,
    super.key,
  }) : child = CachedNetworkImage(
          memCacheWidth: _toInt(memCacheWidth ?? length ?? width, Get.pixelRatio),
          memCacheHeight: _toInt(memCacheHeight ?? length ?? height, Get.pixelRatio),
          width: length ?? width,
          height: length ?? height,
          imageUrl: resizeImage
              ? url.getResizeImageUrl(
                  width: memCacheWidth ?? length ?? width,
                  height: memCacheHeight ?? length ?? height)
              : url,
          alignment: align,
          imageBuilder: (context, imageProvider) {
            return Container(
              width: length ?? width,
              height: length ?? height,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: border,
                shape: shape,
                boxShadow: boxShadow,
                image: DecorationImage(
                  alignment: align,
                  image: imageProvider,
                  fit: fit,
                  opacity: opacity,
                ),
              ),
            );
          },
          placeholder: placeholder != null
              ? (context, url) => placeholder
              : (context, url) => Container(
                    width: length ?? width,
                    height: length ?? height,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: border,
                      shape: shape,
                      color: AppColor.gray2,
                    ),
                  ),
          errorWidget: placeholder != null
              ? (context, url, obj) => placeholder
              : (context, url, obj) => Container(
                    width: length ?? width,
                    height: length ?? height,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: border,
                      shape: shape,
                      color: AppColor.gray2,
                    ),
                  ),
        );

  ///SVGA动效
  ///- repeat 是否重复执行
  ///- animation 是否自动开始动画
  AppImage.svga(
    String assetsName, {
    double? width,
    double? height,
    bool repeat = true,
    bool animation = true,
    ValueChanged<SVGAAnimationController>? onAnimationControllerUpdate,
    ValueChanged<AnimationStatus>? onStatusUpdate,
    super.key,
  }) : child = SVGAView(
          preferredSize:
              width != null && height != null ? Size(width, height) : null,
          assetsName: assetsName,
          repeat: repeat,
          clearsAfterStop: repeat,
          onAnimationControllerUpdate: onAnimationControllerUpdate,
          onStatusUpdate: onStatusUpdate,
          animation: animation,
        );

  ///SVGA动效
  AppImage.networkSvga(
    String url, {
    double? width,
    double? height,
    bool repeat = true,
    ValueChanged<SVGAAnimationController>? onAnimationControllerUpdate,
    ValueChanged<AnimationStatus>? onStatusUpdate,
    super.key,
  }) : child = SVGAView(
          preferredSize:
              width != null && height != null ? Size(width, height) : null,
          resUrl: url,
          repeat: repeat,
          clearsAfterStop: repeat,
          onAnimationControllerUpdate: onAnimationControllerUpdate,
          onStatusUpdate: onStatusUpdate,
        );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class AppDecorations {
  static DecorationImage backgroundImage(
    String assetName, {
    BoxFit fit = BoxFit.fill,
    Rect? centerSlice,
  }) {
    return DecorationImage(
      image: AppAssetImage(assetName),
      fit: fit,
      centerSlice: centerSlice,
    );
  }
}

class AppAssetImage extends AssetImage {
  const AppAssetImage(super.assetName);
}

extension on String {
  ///华为云https://support.huaweicloud.com/usermanual-obs/obs_01_0430.html
  ///OSS云存储裁剪图片
  String getResizeImageUrl({double? width, double? height}) {
    if (width == double.infinity || height == double.infinity) {
      return this;
    }

    const resizePrefix = 'x-oss-process=image/resize';
    final dstWidth = ((width ?? 0) * Get.pixelRatio).toInt();
    final dstHeight = ((height ?? 0) * Get.pixelRatio).toInt();
    if (contains(resizePrefix) ||
        !startsWith('http') ||
        (dstWidth <= 0 && dstHeight <= 0)) {
      return this;
    }
    var process = '$resizePrefix,m_lfit,limit_1';
    if (dstWidth > 0) {
      process += ',w_$dstWidth';
    }
    if (dstHeight > 0) {
      process += ',h_$dstHeight';
    }
    process = (contains('?') ? '&' : '?') + process;
    return this + process;
  }
}
