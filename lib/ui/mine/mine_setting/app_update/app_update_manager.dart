import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/notification/notification_manager.dart';
import 'package:guanjia/common/notification/payload/app_update_payload.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/plugin_util.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'app_update_dialog.dart';

///APP应用内更新
class AppUpdateManager {
  AppUpdateManager._();

  static const _kIgnoreUpdate = 'ignoreUpdate';
  static final instance = AppUpdateManager._();
  final _preferences = LocalStorage('AppUpdateStorage');

  ///正在下载的版本信息
  final downloadUpdateInfoRx = Rxn<AppUpdateVersionModel>();

  ///下载进度0-1
  final downloadProgressRx = 0.0.obs;

  ///检查APP更新
  ///- userAction 是否用户点击检查更新
  Future<void> checkAppUpdate({bool userAction = false}) async {
    if (userAction) {
      Loading.show();
    }
    final info = downloadUpdateInfoRx() ?? await _fetchAppUpdateInfo();
    if (userAction) {
      Loading.dismiss();
      if (info == null) {
        Loading.showToast('当前为最新版本');
      }
    }
    if (info == null) return;

    final ignore = (await _checkIgnoreUpdate(info.version));
    if (!userAction && ignore) {
      return;
    }
    AppUpdateDialog.show(info: info, userAction: userAction);
  }

  Future<void> _showProgressNotification({
    required double progress,
    required String apkFilePath,
    required int notificationId,
  }) async {
    final isFinish = progress == 1;
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationManager.appUpdateChannel.id,
        NotificationManager.appUpdateChannel.name,
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        icon: 'logo',
        maxProgress: 100,
        progress: (progress * 100).toInt(),
        autoCancel: false,
      ),
    );
    await FlutterLocalNotificationsPlugin().show(
      notificationId,
      isFinish ? '下载完成，点击开始安装' : '正在下载',
      '版本更新',
      notificationDetails,
      payload: AppUpdatePayload(
        progress: progress,
        apkFilePath: apkFilePath,
      ).toJsonString(),
    );
  }

  ///设置忽略该版本更新
  Future<bool> setIgnoreUpdate(String version) {
    return _preferences.setString(_kIgnoreUpdate, version);
  }

  ///检查是否忽略该版本更新
  Future<bool> _checkIgnoreUpdate(String version) async {
    final value = await _preferences.getString(_kIgnoreUpdate);
    return value == version;
  }

  ///获取远程版本更新信息
  Future<AppUpdateVersionModel?> _fetchAppUpdateInfo() async {
    final response = await OpenApi.getUpdateVersion(
      version: await AppInfo.getVersion(),
      channel: AppInfo.channel,
    );
    if (response.isSuccess) {
      return response.data;
    }
    return null;
  }

  ///下载并安装
  void downloadAndInstall(AppUpdateVersionModel info) async {
    if(downloadUpdateInfoRx() != null){
      Loading.showToast('正在下载');
      return;
    }

    final dir = await getTemporaryDirectory();
    var tempPath = join(dir.path, '${info.version}.tmp');
    final targetPath = join(dir.path, '${info.link.md5String}.apk');

    //文件已存在，直接安装
    if (await File(targetPath).exists()) {
      downloadProgressRx(1);
      installApk(targetPath);
      return;
    }
    //下载
    Loading.showToast('开始下载');
    downloadUpdateInfoRx(info);
    Dio().download(info.link, tempPath,
        onReceiveProgress: (int count, int total) {
      if (total <= 0) {
        return;
      }
      downloadProgressRx.value = count / total;
      if (count == total && tempPath.isNotEmpty) {
        downloadUpdateInfoRx.value = null;
        File(tempPath)
            .rename(targetPath)
            .then((file) => installApk(file.path));
        tempPath = '';
      }
      _showProgressNotification(
        notificationId: targetPath.hashCode,
        progress: downloadProgressRx(),
        apkFilePath: targetPath,
      );
    }).then((value) {
      if (value.statusCode != 200) {
        Loading.showToast("下载失败，请重试");
        _cleanup(targetPath);
      }
    }).catchError((ex) {
      Loading.showToast("下载失败，请重试");
      _cleanup(targetPath);
    });
  }

  void installApk(String filePath) {
    PluginUtil.installApk(filePath).catchError((ex) {
      _cleanup(filePath);
      return false;
    });
  }

  Future<void> _cleanup(String apkFilePath) async {
    downloadUpdateInfoRx.value = null;
    downloadProgressRx(0);
    if (apkFilePath.isNotEmpty) {
      final targetFile = File(apkFilePath);
      if (await targetFile.exists()) {
        await targetFile.delete();
      }
    }
  }
}
