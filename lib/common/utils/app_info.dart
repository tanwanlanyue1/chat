import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

///App信息
class AppInfo {
  const AppInfo._();

  ///App渠道（官方渠道：official, 华为:huawei，360:360，百度:baidu，oppo:oppo，阿里:ali，小米:xiaomi)
  static const channel = String.fromEnvironment('APP_CHANNEL');

  ///语言版本（中文版：zh  英文版：en）
  static const language = String.fromEnvironment('APP_LANGUAGE');

  ///是否是正式环境包
  static const isRelease = String.fromEnvironment('APP_RELEASE') == 'release';

  ///App版本 CFBundleShortVersionString on iOS, versionName on Android.
  static Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  ///App版本号 CFBundleVersion on iOS, versionCode on Android
  static Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  ///App包名
  static Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  ///App包名
  static Future<String> getAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  ///App系统版本 (例如iOS：17.4，android：11)
  static Future<String> getOSVersion() async {
    final String osVersion;
    if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      osVersion = info.systemVersion;
    } else {
      final info = await DeviceInfoPlugin().androidInfo;
      osVersion = info.version.release;
    }
    return osVersion;
  }

  ///获取手机品牌
  static Future<String> getBrand() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      return "Apple";
    }

    final info = await deviceInfoPlugin.androidInfo;
    return info.brand;
  }

  ///获取手机型号
  static Future<String> getModel() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      return info.utsname.machine;
    }

    final info = await deviceInfoPlugin.androidInfo;
    return info.model;
  }
}
