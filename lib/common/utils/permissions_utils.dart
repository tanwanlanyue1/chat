import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guanjia/widgets/confirm_dialog.dart';

class PermissionsUtils {
  /// 打开系统设置
  static Future<bool> openAppSetting() async {
    return await openAppSettings();
  }

  /// 请求相册权限
  static Future<bool> requestPhotosPermission(
      {bool isOpenSetting = true}) async {
    return await _requestPermission(Permission.photos,
        isOpenSetting: isOpenSetting);
  }

  /// 请求相机权限
  static Future<bool> requestCameraPermission(
      {bool isOpenSetting = true}) async {
    return await _requestPermission(Permission.camera,
        isOpenSetting: isOpenSetting);
  }

  /// 请求存储权限（保存图片到本地）
  static Future<bool> requestStoragePermission(
      {bool isOpenSetting = true}) async {
    return await _requestPermission(
        GetPlatform.isIOS ? Permission.photosAddOnly : Permission.storage,
        isOpenSetting: isOpenSetting);
  }

  /// 请求通知权限
  static Future<bool> requestNotificationPermission(
      {bool isOpenSetting = true}) async {
    return await _requestPermission(Permission.notification,
        isOpenSetting: isOpenSetting);
  }

  /// 获取相册权限
  static Future<bool> getPhotosPermission() async {
    final status = await Permission.photos.status;
    return _processingStatus(status);
  }

  /// 获取相机权限
  static Future<bool> getCameraPermission() async {
    final status = await Permission.camera.status;
    return _processingStatus(status);
  }

  /// 获取存储权限（保存图片到本地）
  static Future<bool> getStoragePermission() async {
    final status = GetPlatform.isIOS
        ? await Permission.photosAddOnly.status
        : await Permission.storage.status;
    return _processingStatus(status);
  }

  /// 获取通知权限
  static Future<bool> getNotificationPermission() async {
    final status = await Permission.notification.status;
    return _processingStatus(status);
  }

  // 请求单个权限
  static Future<bool> _requestPermission(Permission permissionType,
      {bool isOpenSetting = true}) async {
    var status = await permissionType.status;
    if (status.isDenied) {
      status = await permissionType.request();
    }

    final isGranted = _processingStatus(status);

    // 如果权限被限制 并且 允许打开跳转 跳转到系统设置权限界面
    if (!isGranted && isOpenSetting) {
      const message = '需要同意权限才可以该功能';
      final result = await ConfirmDialog.show(
          message: const Text(message), okButtonText: const Text('前往设置'));
      if (result) {
        Future.delayed(const Duration(milliseconds: 300), openAppSettings);
      }
    }

    return isGranted;
  }

  // 处理特殊状态
  static bool _processingStatus(PermissionStatus status) {
    // 如果是limited状态，也认为是允许的
    if (status == PermissionStatus.limited) {
      return true;
    }

    final isGranted = status.isGranted;
    return isGranted;
  }
}
