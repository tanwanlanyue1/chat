import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///App全局配置服务
class NotificationService extends GetxService with WidgetsBindingObserver {
  final _instance = Getuiflut();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    if (GetPlatform.isIOS) {
      // 启动sdk+通知授权
      _instance.startSdk(
          appId: AppConfig.geTuiAppId,
          appKey: AppConfig.geTuiAppKey,
          appSecret: AppConfig.geTuiAppSecret);
    } else {
      Getuiflut.initGetuiSdk;
      _instance.onActivityCreate();
    }

    //杀进程点击通知消息打开APP，需要通过该方法获取通知消息携带的数据
    // Getuiflut.getLaunchNotification.then((data){
    //   AppLogger.d('启动参数：$data');
    //   if(data.isNotEmpty){
    //     _onClickNotification(data);
    //   }else{
    //     resetBadge();
    //   }
    // });

    _instance.addEventHandler(
      // 注册收到 cid 的回调
      onReceiveClientId: (String message) async {
        debugPrint("NotificationService onReceiveClientId: $message");
      },
      // 注册 DeviceToken 回调
      onRegisterDeviceToken: (String message) async {
        debugPrint("NotificationService onRegisterDeviceToken: $message");
      },
      onReceiveMessageData: (Map<String, dynamic> event) async {
        debugPrint("NotificationService onReceiveMessageData: $event");
      },
      onNotificationMessageArrived: (Map<String, dynamic> event) async {
        debugPrint("NotificationService onNotificationMessageArrived: $event");
      },
      onNotificationMessageClicked: (Map<String, dynamic> event) async {
        debugPrint("NotificationService onNotificationMessageClicked: $event");
      },
      onTransmitUserMessageReceive: (Map<String, dynamic> event) async {
        debugPrint("NotificationService onTransmitUserMessageReceive: $event");
      },

      /// iOS
      // 收到的透传内容
      onReceivePayload: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onReceivePayload: $message");
      },
      ///点击通知回调（iOS）
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        AppLogger.d("getui onReceiveNotificationResponse: $message");
        _onClickNotification(message);
      },
      // 收到AppLink消息
      onAppLinkPayload: (String message) async {
        debugPrint("NotificationService onAppLinkPayload: $message");
      },
      // 收到pushmode回调
      onPushModeResult: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onPushModeResult: $message");
      },
      // 收到setTag回调
      onSetTagResult: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onSetTagResult: $message");
      },
      // 收到别名回调
      onAliasResult: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onAliasResult: $message");
      },
      // 收到查询tag回调
      onQueryTagResult: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onQueryTagResult: $message");
      },
      // 收到APNs即将展示回调
      onWillPresentNotification: (Map<String, dynamic> message) async {
        debugPrint("NotificationService onWillPresentNotification: $message");
      },
      // 收到APNs通知设置跳转回调
      onOpenSettingsForNotification: (Map<String, dynamic> message) async {
        debugPrint(
            "NotificationService onOpenSettingsForNotification: $message");
      },
      // 通知授权结果
      onGrantAuthorization: (String granted) async {
        debugPrint("NotificationService onGrantAuthorization: $granted");
      },
      // 收到实时活动（灵动岛）token回调
      onLiveActivityResult: (Map<String, dynamic> event) async {
        debugPrint("NotificationService onLiveActivityResult: $event");
      },
    );
  }

  void _onClickNotification(Map<dynamic, dynamic> message) {
    resetBadge();
    //TODO  解析通知数据，跳转页面
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resetBadge();
    }
  }

  /// 获取Cid
  Future<String> getCid() async {
    return await Getuiflut.getClientId;
  }

  /// 重置角标
  void resetBadge() {
    _instance.setLocalBadge(0);
    _instance.resetBadge();
  }
}
