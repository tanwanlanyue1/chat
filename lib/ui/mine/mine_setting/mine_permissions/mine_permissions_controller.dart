import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/generated/l10n.dart';

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
        title: S.current.authorityNotify,
        detail: S.current.usedToYouNotification,
        type: MinePermissionsItemType.notification,
        isOpen: await PermissionsUtils.getNotificationPermission(),
      ),
      if (isShowCamera)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_camera.png",
          title: S.current.cameraPermission,
          detail: S.current.pictureUpload,
          type: MinePermissionsItemType.camera,
          isOpen: await PermissionsUtils.getCameraPermission(),
        ),
      if (isShowPhotos)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_photo.png",
          title: S.current.albumPermission,
          detail: S.current.photoAlbumUpload,
          type: MinePermissionsItemType.photos,
          isOpen: await PermissionsUtils.getPhotosPermission(),
        ),
      if (isShowStorage)
        MinePermissionsItem(
          icon: "assets/images/mine/mine_storage.png",
          title: S.current.storagePermission,
          detail: S.current.saveImages,
          type: MinePermissionsItemType.storage,
          isOpen: await PermissionsUtils.getStoragePermission(),
        ),
    ]);

    update();
  }
}
