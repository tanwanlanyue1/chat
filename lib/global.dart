import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/ad/ad_manager.dart';
import 'package:guanjia/ui/welcome/welcome_storage.dart';

import 'common/app_localization.dart';
import 'common/app_position.dart';
import 'common/service/service.dart';
import 'ui/chat/chat_manager.dart';

/// 全局静态数据
class Global with WidgetsBindingObserver{
  Global._(){
    WidgetsBinding.instance.addObserver(this);
  }
  static final _instance = Global._();
  factory Global() => _instance;

  static Completer<bool>? _completer;

  ///应用声明周期状态
  final appStateRx = AppLifecycleState.resumed.obs;

  /// 初始化
  static Future<bool> initialize() async {
    try {

      if (_completer?.isCompleted == true) {
        return true;
      }
      final completer = _completer;
      if (completer != null) {
        return completer.future;
      }
      _completer = Completer<bool>();


      //android状态栏透明
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        );
      }

      //多语言支持
      await AppLocalization.instance.initialize();

      //网络请求客户端初始化
      HttpClient.initialize(
        authenticationHeaderProvider: getAuthorizedHeaders,
        onUnauthorized: () => SS.login.onUnauthorized(),
        logger: TBHttpClientLogger(
          responseHeader: false,
          responseBody: true,
          logPrint: AppLogger.d,
        ),
      );

      await WelcomeStorage.initialize();
      WelcomeStorage.saveAdFirstOpen([]);
      if(WelcomeStorage.isPrivacyAgree){
        await _initAfterPrivacyPolicy();
      }
    } catch (ex) {
      AppLogger.w(ex);
    }
    _completer?.complete(true);
    return true;
  }

  ///用户点击同意隐私政策
  static Future<void> agreePrivacyPolicy() async{
    await WelcomeStorage.savePrivacyAgree();
    await _initAfterPrivacyPolicy();
  }


  ///用户同意隐私政策之后执行初始化，androidId，第三方sdk等敏感信息需要用户同意隐私政策才可以获取，否则应用市场审核不过
  static Future<void> _initAfterPrivacyPolicy() async {

    //初始化IM服务
    await ChatManager().init();

    //初始化服务
    await SS.initServices();

    await AppPosition.updatePosition();

    //广告
    await ADManager.instance.initialize();

  }

  static Future<Map<String, dynamic>> getAuthorizedHeaders() async {
    final loginService = SS.login;

    final userId = loginService.userId;

    // 如果用户id为空，代表未登录，直接返回空Map
    if (userId == null) {
      return {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final token =
        "${loginService.token ?? ""}${loginService.userId ?? ""}$timestamp";

    final headers = <String, dynamic>{
      'timeStamp': timestamp,
      'userId': userId.toString(),
      "token": token.md5String,
    };

    return headers;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appStateRx.value = state;
  }
}
