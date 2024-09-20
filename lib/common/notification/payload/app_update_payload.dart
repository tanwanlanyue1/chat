
import 'dart:convert';

import 'package:guanjia/common/extension/iterable_extension.dart';

///App更新下载进度通知Payload
class AppUpdatePayload {

  ///进度0-1.0
  final double progress;

  ///APK文件路径，下载完成才会有值
  final String apkFilePath;

  AppUpdatePayload({required this.progress, required this.apkFilePath});

  static AppUpdatePayload? fromJson(Map<String, dynamic> json){
    final progress = json.getDoubleOrNull('progress');
    final apkFilePath = json.getStringOrNull('apkFilePath');
    if(progress != null && apkFilePath != null){
      return AppUpdatePayload(progress: progress, apkFilePath: apkFilePath);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'progress': progress,
    'apkFilePath': apkFilePath,
  };

  String toJsonString() => jsonEncode(toJson());
}