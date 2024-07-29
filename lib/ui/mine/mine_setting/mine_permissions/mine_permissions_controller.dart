import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';

import 'mine_permissions_state.dart';

class MinePermissionsController extends GetxController
    with WidgetsBindingObserver {
  final MinePermissionsState state = MinePermissionsState();

  bool isShowCamera = true;
  bool isShowPhotos = true;
  bool isShowStorage = true;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    _fetchPermissionData();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void onTapAppSetting(MinePermissionsItemType type) async {
    switch (type) {
      case MinePermissionsItemType.photos:
        await PermissionsUtils.requestPhotosPermission();
        break;
      case MinePermissionsItemType.camera:
        await PermissionsUtils.requestCameraPermission();
        break;
      case MinePermissionsItemType.storage:
        await PermissionsUtils.requestStoragePermission();
        break;
      case MinePermissionsItemType.notification:
        await PermissionsUtils.requestNotificationPermission();
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _fetchPermissionData();
    }
  }

  Future<void> _fetchPermissionData() async {
    final isIOS = GetPlatform.isIOS;

    isShowCamera = isIOS;

    if (!isIOS) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        isShowPhotos = false;
      } else {
        isShowStorage = false;
      }
    }

    state.items.clear();
    state.items.addAll([
      MinePermissionsItem(
        icon: "assets/images/mine/mine_notification.png",
        title: "通知权限",
        detail: "用于给你提供即时通知服务，以便你即时接收账号消息及个性化广告推送",
        type: MinePermissionsItemType.notification,
        isOpen: await PermissionsUtils.getNotificationPermission(),
      ),
      if (isShowCamera)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_camera.png",
          title: "相机权限",
          detail: "头像上传、发布创作信息时选择图片上传需要使用你的手机相机功能",
          type: MinePermissionsItemType.camera,
          isOpen: await PermissionsUtils.getCameraPermission(),
        ),
      if (isShowPhotos)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_photo.png",
          title: "相册权限",
          detail: "头像上传、发布创作信息时选择图片上传需要访问你的手机相册信息",
          type: MinePermissionsItemType.photos,
          isOpen: await PermissionsUtils.getPhotosPermission(),
        ),
      if (isShowStorage)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_storage.png",
          title: "存储权限",
          detail: "允许保存图片至本地相册，需要获取存储空间权限",
          type: MinePermissionsItemType.storage,
          isOpen: await PermissionsUtils.getStoragePermission(),
        ),
    ]);

    update();
  }
}
