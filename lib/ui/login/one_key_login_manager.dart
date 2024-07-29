import 'dart:async';
import 'package:ali_auth/ali_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

///一键登录管理器
class OneKeyLoginManager with WidgetsBindingObserver {
  final _onEnvAvailableStreamController = StreamController<bool>.broadcast();

  final _onFetchTokenSuccessController = StreamController<String>.broadcast();

  ///环境可用状态监听
  Stream<bool> get onEnvAvailableStream =>
      _onEnvAvailableStreamController.stream;

  ///成功登录监听
  Stream<String> get onFetchTokenSuccessStream =>
      _onFetchTokenSuccessController.stream;

  StreamSubscription? _connectivityChangedSubscription;

  ///初始化
  void initialize() async {
    WidgetsBinding.instance
      ..removeObserver(this)
      ..addObserver(this);

    //监听登录状态
    AliAuth.loginListen(onEvent: (value) {
      debugPrint('AliAuth onEvent=$value');

      if (value is! Map) return;

      final code = (value['code'] ?? '') as String;
      final data = value['data'];
      final msg = value['msg'];

      if (![_ResultCode.launchPluginSuccess, _ResultCode.clientCheck]
          .contains(code)) {
        Loading.dismiss();
      }

      switch (code) {
        case _ResultCode.clickOtherLoginMethod:
          AliAuth.quitPage();
          break;
        case _ResultCode.cancelLogin:
          AliAuth.quitPage();
          break;
        case _ResultCode.fetchTokenSuccess:
          if (data != null && data is String) {
            _onFetchTokenSuccessController.add(data);
          }
          break;
        // case _ResultCode.cellularNetworkUnavailable:
        //   if (msg != null && msg is String) {
        //     Loading.showToast(msg);
        //   }
        //   break;
        case _ResultCode.schemeNumberNotExists:
        case _ResultCode.unknownError:
        case _ResultCode.fetchTokenError:
        case _ResultCode.unavailable:
        case _ResultCode.overLimit:
        case _ResultCode.timeout:
        case _ResultCode.checkFailure:
        case _ResultCode.parameterError:
          Loading.showToast('登录失败，请使用其他登录方式');
          break;
      }
    }, onError: (err) {
      debugPrint('OneKeyLoginManager onError: $err');
      Loading.dismiss();
    });

    _connectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      _checkEnvAvailable();
    });

    initSdk();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkEnvAvailable();
    }
  }

  void _checkEnvAvailable() async {
    final value = await AliAuth.checkEnvAvailable(AppConfig.aliyunAndroidSk);
    _onEnvAvailableStreamController.add(value ?? true);
  }

  void initSdk() {
    // 初始化sdk
    AliAuth.initSdk(getConfig(isDelay: true));
  }

  ///打开授权页
  ///- onFetchTokenSuccess
  ///- isPhoneBinding
  Future<void> openAuthPage({
    bool isPhoneBinding = false,
  }) async {
    Loading.show();
    //初始化并打开授权页
    AliAuth.initSdk(getConfig(isPhoneBinding: isPhoneBinding));
  }

  AliAuthModel getConfig({bool isPhoneBinding = false, bool isDelay = false}) {
    const backgroundColor = '#F6ECE0';

    //logo 位置
    final logoBounds = Rect.fromLTWH(0, 64.rpx, 102.rpx, 102.rpx);

    //手机号码 位置
    final phoneNumberBounds =
        Rect.fromLTWH(0, logoBounds.bottom + 64.rpx, 0, 34.rpx);

    //未注册手机一键登录后自动创建账号 位置
    final sloganBounds =
        Rect.fromLTWH(0, phoneNumberBounds.bottom + 60.rpx, 0, 14.rpx);

    //登录按钮 位置
    final loginButtonBounds =
        Rect.fromLTWH(0, sloganBounds.bottom + 12.rpx, 280.rpx, 42.rpx);

    //协议 位置
    final protocolBounds = Rect.fromLTWH(0, Get.height - 156.rpx, 0, 28.rpx);

    //关闭页面按钮
    final returnButton = CustomView(
      8.rpx.toInt(),
      null,
      null,
      16.rpx.toInt(),
      32.rpx.toInt(),
      32.rpx.toInt(),
      'assets/images/mine/back.png',
      ScaleType.center,
    );

    return AliAuthModel(
      AppConfig.aliyunAndroidSk,
      AppConfig.aliyunIOSSk,
      isDelay: isDelay,
      isDebug: kDebugMode,
      pageType: PageType.customView,
      statusBarColor: backgroundColor,
      // isLightColor: true,
      // navHidden: true,
      // customReturnBtn: returnButton,
      navColor: '#00000000',
      navReturnImgPath: 'assets/images/mine/back120.png',
      navReturnImgHeight: 40.rpx.toInt(),
      navReturnImgWidth: 40.rpx.toInt(),
      navReturnScaleType: ScaleType.fitXy,
      navText: '',
      pageBackgroundPath: 'assets/images/login/one_key_login_bg.png',
      logoImgPath: 'assets/images/login/login_logo.png',
      logoWidth: logoBounds.width.toInt(),
      logoHeight: logoBounds.height.toInt(),
      logoScaleType: ScaleType.fitXy,
      logoOffsetY: logoBounds.top.toInt(),
      logoHidden: false,
      checkboxHidden: false,
      checkBoxWidth: 16.rpx.toInt(),
      checkBoxHeight: 16.rpx.toInt(),
      uncheckedImgPath: 'assets/images/login/login_choose_normal.png',
      checkedImgPath: 'assets/images/login/login_choose_select.png',
      numberSize: 34.rpx.toInt(),
      numberColor: '#000000',
      numFieldOffsetY: phoneNumberBounds.top.toInt(),
      sloganOffsetY: sloganBounds.top.toInt(),
      sloganTextSize: 12.rpx.toInt(),
      sloganTextColor: '#C09B8D',
      sloganText: '未注册手机一键登录后自动创建账号',
      protocolGravity: Gravity.centerHorizntal,
      protocolColor: '#C09B8D',
      protocolCustomColor: '#000000',
      protocolOwnColor: '#000000',
      protocolOwnOneColor: '#000000',
      protocolOwnTwoColor: '#000000',
      // protocolOwnThreeColor: '#000000',
      protocolOneName: '用户协议',
      protocolOneURL: AppConfig.urlUserService,
      protocolTwoName: '隐私政策',
      protocolTwoURL: AppConfig.urlPrivacyPolicy,
      protocolThreeName: '',
      protocolThreeURL: '',
      privacyEnd: '并授权使用本机号码注册/登录账号',
      privacyTextSize: 11.rpx.toInt(),
      privacyOffsetY: protocolBounds.top.toInt(),
      vendorPrivacyPrefix: '',
      vendorPrivacySuffix: '',
      logBtnWidth: loginButtonBounds.width.toInt(),
      logBtnHeight: loginButtonBounds.height.toInt(),
      logBtnOffsetY: loginButtonBounds.top.toInt(),
      logBtnText: isPhoneBinding ? '本机号码一键绑定' : '本机号码一键登录',
      logBtnTextColor: '#FFFFFF',
      logBtnTextSize: 15.rpx.toInt(),
      logBtnBackgroundPath:
          'assets/images/login/onekey_login_btn.png,assets/images/login/onekey_login_btn.png,assets/images/login/onekey_login_btn.png',
      switchAccHidden: true,
      webViewStatusBarColor: '#FFFFFF',
      webNavColor: '#FFFFFF',
      webNavReturnImgPath: 'assets/images/mine/back120.png',
      webNavTextColor: '#000000',
      webSupportedJavascript: true,
      privacyAlertIsNeedShow: true,
      privacyAlertMaskAlpha: 0.5,
      privacyAlertAlpha: 1.0,
      privacyAlertTitleBackgroundColor: '#FFFFFF',
      privacyAlertBackgroundColor: '#FFFFFF',
      privacyAlertContentBackgroundColor: '#FFFFFF',
      privacyAlertCornerRadiusArray: [
        12.rpx.toInt(),
        12.rpx.toInt(),
        12.rpx.toInt(),
        12.rpx.toInt()
      ],
      privacyAlertAlignment: Gravity.centerHorizntal,
      privacyAlertWidth: 320.rpx.toInt(),
      privacyAlertHeight: 200.rpx.toInt(),
      privacyAlertCloseBtnShow: true,
      privacyAlertCloseImgWidth: 18.rpx.toInt(),
      privacyAlertCloseImgHeight: 32.rpx.toInt(),
      privacyAlertCloseScaleType: ScaleType.center,
      privacyAlertTitleColor: '#000000',
      privacyAlertContentTextSize: 14.rpx.toInt(),
      privacyAlertContentBaseColor: '#999999',
      privacyAlertContentColor: '#333333',
      privacyAlertOwnOneColor: '#333333',
      privacyAlertOwnTwoColor: '#333333',
      privacyAlertOwnThreeColor: '#333333',
      privacyAlertContentHorizontalMargin: 16.rpx.toInt(),
      privacyAlertBtnBackgroundImgPath:
          'assets/images/login/onekey_login_agree_btn.png',
      privacyAlertBtnTextColor: '#FFFFFF',
      privacyAlertBtnTextSize: 15.rpx.toInt(),
      privacyAlertBtnWidth: 180.rpx.toInt(),
      privacyAlertBtnHeigth: 40.rpx.toInt(),
      isHideToast: false,
    );
  }

  void dispose() {
    AliAuth.dispose();
    _connectivityChangedSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}

///结果码 https://help.aliyun.com/document_detail/2249369.html?spm=a2c4g.2249362.0.0.5e132a2ab5v4Ar
class _ResultCode {
  _ResultCode._();

  ///插件启动监听成功
  static const launchPluginSuccess = '500004';

  ///唤起授权页成功
  static const launchPageSuccess = '600001';

  ///方案号不存在
  static const schemeNumberNotExists = '600004';

  ///未知异常。
  static const unknownError = '600010';

  ///获取Token失败
  static const fetchTokenError = '600011';

  ///运营商维护升级，该功能不可用
  static const unavailable = '600013';

  ///运营商维护升级，该功能调用次数已达上限
  static const overLimit = '600014';

  ///接口超时
  static const timeout = '600015';

  ///终端环境检查⽀持认证。
  static const clientCheck = '600024';

  ///接入方身份信息校验失败。
  static const checkFailure = '600025';

  ///入参错误（AccessToken，JwtToken）
  static const parameterError = '600028';

  ///点击其他登录方式
  static const clickOtherLoginMethod = '600019';

  ///获取取号token成功
  static const fetchTokenSuccess = '600000';

  ///移动网络未开启
  static const cellularNetworkUnavailable = '600008';

  ///用户取消登录
  static const cancelLogin = '700000';
}
