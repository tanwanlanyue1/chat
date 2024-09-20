import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/widgets/confirm_dialog.dart';

class NotificationPermissionUtil with WidgetsBindingObserver {
  static NotificationPermissionUtil? _instance;

  static NotificationPermissionUtil get instance =>
      _instance ??= NotificationPermissionUtil._();
  final _prefs = LocalStorage('NotificationPermissionUtil');

  //一个小时内只允许申请一次通知权限
  static const _requestDelayMs = 3600 * 1000;
  static const _keyRequestDelayMs = 'delayMs';

  ///是否已打开通知栏权限
  final isGrantedRx = false.obs;

  NotificationPermissionUtil._();

  Future<void> initialize() async {
    WidgetsBinding.instance..removeObserver(this)..addObserver(this);
    await _refresh();
    _requestIfNeed();
  }


  ///请求通知权限
  ///- return 是否允许
  Future<bool> request() async {
    final state = await Permission.notification.request();
    if(!state.isGranted){
      final isOk = await ConfirmDialog.show(
        message: const Text('请开启通知权限，以便接收最新消息'),
        okButtonText: const Text('开启权限'),
      );
      if(isOk){
        PermissionsUtils.openAppSetting();
      }
    }
    isGrantedRx.value = state.isGranted;
    return state.isGranted;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    isGrantedRx.value = await Permission.notification.isGranted;
  }

  ///请求通知权限，一个小时内只允许申请一次通知权限
  void _requestIfNeed() async {
    if(isGrantedRx.isTrue){
      return;
    }
    await _refresh();
    if(isGrantedRx.isTrue){
      return;
    }

    final timestamp = (await _prefs.getInt(_keyRequestDelayMs)) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - timestamp > _requestDelayMs) {
      _prefs.setInt(_keyRequestDelayMs, now).ignore();
      Permission.notification.request().ignore();
    } else {
      AppLogger.d('距离上一次申请通知权限未超过1个小时');
    }
  }
}
