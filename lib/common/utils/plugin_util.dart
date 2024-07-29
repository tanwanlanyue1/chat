import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// 通用插件，桥接到原生
class PluginUtil {
  PluginUtil._();
  static const MethodChannel _methodChannel = MethodChannel('com.qt.jx/plugin');

  static Future<String?> getDeviceId() async {
    try {
      return _methodChannel.invokeMethod<String>('getDeviceId');
    }catch (ex) {
      debugPrint("PluginUtil Failed to get device ID: '$ex'.");
      return null;
    }
  }

  ///安装apk
  static Future<bool> installApk(String filePath) async {
    try {
      final result =
      await _methodChannel.invokeMethod<bool>('installApk', filePath);
      return result as bool;
    } catch (ex) {
      debugPrint('installApk error: $ex');
      return false;
    }
  }
}
