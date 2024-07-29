import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/widgets/widgets.dart';

///图片相册工具
class ImageGalleryUtils {
  ImageGalleryUtils._();

  ///保存网路图片到相册
  static Future<bool> saveNetworkImage(String url) async {
    if(!await _checkPermission()){
      return false;
    }

    Loading.show();
    var result = false;
    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      result = await _saveFile(file.path);
    } catch (ex) {
      AppLogger.w('文件下载失败, ex=$ex');
    }
    Loading.dismiss();
    Loading.showToast(result ? '保存成功' : '保存失败');
    return result;
  }

  ///将widget转为图片并保存到相册
  static Future<bool> saveWidgetImage({
    required BuildContext context,
    required GlobalKey repaintKey,
  }) async {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    if(!await _checkPermission()){
      return false;
    }

    final obj = repaintKey.currentContext?.findRenderObject();
    if (obj is! RenderRepaintBoundary) {
      Loading.showToast('保存失败');
      AppLogger.w('render object is not RenderRepaintBoundary');
      return false;
    }

    Loading.show();
    final image =
        await obj.toImage(pixelRatio: devicePixelRatio);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    if (bytes == null) {
      Loading.dismiss();
      Loading.showToast('保存失败');
      AppLogger.w('image bytes null');
      return false;
    }

    final result = await _saveImage(bytes);
    Loading.dismiss();
    Loading.showToast(result ? '保存成功' : '保存失败');
    return result;
  }

  ///检查存储权限
  static Future<bool> _checkPermission() async {
    var permission = Platform.isAndroid ? Permission.photos : Permission.photosAddOnly;
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      //android13之前申请storage权限
      if(androidInfo.version.sdkInt < 33){
        permission = Permission.storage;
      }
    }
    final isGranted = await permission.isGranted;
    if (isGranted) {
      return true;
    }
    const message = '需要同意权限才可以使用保存到相册功能';

    //提前弹出提示对话框（华为上架要求)
    if (Platform.isAndroid) {
      final result = await ConfirmDialog.show(
        message: const Text(message),
      );
      if(!result){
        AppLogger.w('用户不同意权限请求');
        return false;
      }
    }
    //请求权限
    final status = await permission.request();
    if(status.isGranted){
      return true;
    }
    //用户不同意，继续提醒用户手动开启权限
    final result = await ConfirmDialog.show(
      message: const Text(message),
      okButtonText: const Text('前往设置')
    );
    if(result){
      Future.delayed(const Duration(milliseconds: 300), openAppSettings);
    }
    return false;
  }

  static Future<bool> _saveImage(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
    bool isReturnImagePathOfIOS = false,
  }) async {
    try {
      final result = await ImageGallerySaver.saveImage(imageBytes,
          quality: quality,
          name: name,
          isReturnImagePathOfIOS: isReturnImagePathOfIOS);
      return result is Map && result['isSuccess'] == true;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> _saveFile(
    String file, {
    String? name,
    bool isReturnPathOfIOS = false,
  }) async {
    try {
      final result = await ImageGallerySaver.saveFile(file,
          name: name, isReturnPathOfIOS: isReturnPathOfIOS);
      return result is Map && result['isSuccess'] == true;
    } catch (ex) {
      return false;
    }
  }
}
