import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

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
    final String? heroTag, //HeroTag前缀
    super.key,
  }) : child = _wrapHero(
          tag: heroTag != null ? heroTag + file.path : null,
          child: Image(
            image: ResizeImage(
              FileImage(file),
              width: _toInt(length ?? width, Get.pixelRatio),
            ),
            width: length ?? width,
            height: length ?? height,
            color: color,
            opacity: opacity,
            fit: fit,
            alignment: alignment,
          ),
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
    Duration fadeDuration = const Duration(milliseconds: 300),
    final String? heroTag, //HeroTag前缀
    super.key,
  }) : child = _wrapHero(
          tag: heroTag != null ? heroTag + url : null,
          child: CachedNetworkImage(
            memCacheWidth:
                _toInt(memCacheWidth ?? length ?? width, Get.pixelRatio),
            memCacheHeight:
                _toInt(memCacheHeight ?? length ?? height, Get.pixelRatio),
            width: length ?? width,
            height: length ?? height,
            imageUrl: resizeImage
                ? url.getResizeImageUrl(
                    width: memCacheWidth ?? length ?? width,
                    height: memCacheHeight ?? length ?? height)
                : url,
            alignment: align,
            fadeInDuration: fadeDuration,
            fadeOutDuration: fadeDuration,
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
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: border,
                        shape: shape,
                        color: AppColor.background,
                      ),
                      child: AppImage.asset(
                        'assets/images/common/default_img.png',
                        size: getDefaultIconSize(
                          width: length ?? width,
                          height: length ?? height,
                        ),
                      ),
                    ),
            errorWidget: placeholder != null
                ? (context, url, obj) => placeholder
                : (context, url, obj) => Container(
                      width: length ?? width,
                      height: length ?? height,
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: border,
                        shape: shape,
                        color: AppColor.background,
                      ),
                      child: AppImage.asset(
                        'assets/images/common/default_img.png',
                        size: getDefaultIconSize(
                          width: length ?? width,
                          height: length ?? height,
                        ),
                      ),
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

extension StringImageResize on String {
  ///华为云https://support.huaweicloud.com/usermanual-obs/obs_01_0430.html
  ///OSS云存储裁剪图片
  String getResizeImageUrl(
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (width == null && height == null) {
      return this;
    }
    if (width == double.infinity || height == double.infinity) {
      return this;
    }
    return _resizeForAmazonaws(width: width, height: height)
        ._resizeForOSS(width: width, height: height);
  }

  ///阿里云图片裁剪
  String _resizeForOSS(
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (width == double.infinity ||
        height == double.infinity ||
        contains('amazonaws.com')) {
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
    var mode = 'm_lfit';
    switch (fit) {
      case BoxFit.fill:
        mode = 'm_fixed';
        break;
      case BoxFit.contain:
      case BoxFit.fitWidth:
      case BoxFit.fitHeight:
      case BoxFit.scaleDown:
        mode = 'm_lfit';
        break;
      case BoxFit.cover:
        mode = 'm_fill';
        break;
      case BoxFit.none:
        mode = 'm_mfit';
        break;
    }

    var process = '$resizePrefix,$mode,limit_1';
    if (dstWidth > 0) {
      process += ',w_$dstWidth';
    }
    if (dstHeight > 0) {
      process += ',h_$dstHeight';
    }
    process = (contains('?') ? '&' : '?') + process;
    return this + process;
  }

  ///亚马逊图片裁剪
  String _resizeForAmazonaws(
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (width == double.infinity ||
        height == double.infinity ||
        !contains('amazonaws.com')) {
      return this;
    }

    final amazonawsCloudFront = SS.appConfig.configRx()?.amazonawsCloudFront;
    if (amazonawsCloudFront == null ||
        !amazonawsCloudFront.startsWith('http')) {
      return this;
    }

    final uri = Uri.tryParse(this);
    if (uri == null) {
      return this;
    }
    final bucket = uri.authority.split('.').firstOrNull;
    var key = uri.path;
    if (key.startsWith('/')) {
      key = key.substring(1);
    }
    final resize = <String, dynamic>{};
    final dstWidth = ((width ?? 0) * Get.pixelRatio).toInt();
    final dstHeight = ((height ?? 0) * Get.pixelRatio).toInt();
    if (dstWidth > 0) {
      resize['width'] = dstWidth;
    }
    if (dstHeight > 0) {
      resize['height'] = dstHeight;
    }

    if (resize.isEmpty) {
      return this;
    }

    switch (fit) {
      case BoxFit.fill:
      case BoxFit.cover:
        resize['fit'] = fit.name;
        break;
      case BoxFit.contain:
      case BoxFit.scaleDown:
      case BoxFit.fitWidth:
      case BoxFit.fitHeight:
        resize['fit'] = 'inside';
        break;
      case BoxFit.none:
        resize['fit'] = 'outside';
        break;
    }

    final options = {
      "bucket": bucket,
      "key": key,
      "edits": {
        "resize": resize,
      }
    };
    // ///亚马逊图片裁剪URL
    // static const amazonawsCloudFront = 'https://d3ls09x25n4qi9.cloudfront.net/';
    try {
      var value = jsonEncode(options);
      value = Uri.decodeComponent(value);
      value = base64Encode(utf8.encode(value));
      return amazonawsCloudFront + value;
    } catch (ex) {
      return this;
    }
  }
}

double getDefaultIconSize({double? width, double? height}) {
  final defaultSize = 50.rpx;
  final size = min(width ?? 0, height ?? 0) * 0.2;
  if (size == 0) {
    return defaultSize;
  }
  if (size > defaultSize) {
    return defaultSize;
  }
  return size;
}

Widget _wrapHero({required Widget child, String? tag}) {
  if (tag != null) {
    return Hero(tag: tag, child: child);
  }
  return child;
}
