import 'dart:io';

class SystemPlatform {
  SystemPlatform._();

  static final bool isLinux = Platform.isLinux;

  static final bool isMacOS = Platform.isMacOS;

  static final bool isWindows = Platform.isWindows;

  static final bool isAndroid = Platform.isAndroid;

  static final bool isIOS = Platform.isIOS;

  static final bool isFuchsia = Platform.isFuchsia;

  static const bool isWeb = false;

  static final String operatingSystem = Platform.operatingSystem;

  static final String operatingSystemVersion = Platform.operatingSystemVersion;
}
