import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:guanjia/common/utils/file_logger.dart';

/// 通用插件，桥接到原生
class PluginUtil {
  PluginUtil._();
  static const MethodChannel _methodChannel = MethodChannel('com.social.guanjia/plugin');

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

  ///获取APP启动参数 TODO iOS未实现
  static Future<Map<dynamic, dynamic>> getAppLaunchOptions() async{
    try {
      final result =
      await _methodChannel.invokeMethod<Map<dynamic, dynamic>>('getAppLaunchOptions');
      return result ?? {};
    } catch (ex) {
      debugPrint('getAppLaunchOptions error: $ex');
      FileLogger.d('getAppLaunchOptions error: $ex');
    }
    return {};
  }

}
