// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

// Project imports:
import 'package:zego_uikit/src/plugins/beauty/impl/core/data.dart';

/// @nodoc
class ZegoBeautyPluginCore {
  ZegoBeautyPluginCore._internal();

  static ZegoBeautyPluginCore shared = ZegoBeautyPluginCore._internal();
  ZegoBeautyPluginCoreData coreData = ZegoBeautyPluginCoreData();

  /// get version
  Future<String> getVersion() async {
    return ZegoPluginAdapter().beautyPlugin?.getVersion() ??
        Future.value('beautyPlugin:null');
  }

  /// init
  Future<void> init({
    required int appID,
    String appSign = '',
    String licence = '',
  }) async {
    // initEvent();
    coreData.create(
      appID: appID,
      appSign: appSign,
      licence: licence,
    );
  }

  /// uninit
  Future<void> uninit() async {
    // uninitEvent();
    return coreData.destroy();
  }

  /// setConfig
  void setConfig(ZegoBeautyPluginConfig config) {
    coreData.setConfig(config);
  }

  /// showBeautyUI
  void showBeautyUI(BuildContext context) {
    coreData.showBeautyUI(context);
  }

  Stream<ZegoBeautyError> getErrorStream() {
    return coreData.getErrorStream();
  }
}
