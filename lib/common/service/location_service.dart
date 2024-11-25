import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///位置服务
class LocationService extends GetxService with WidgetsBindingObserver {
  ///是否启用位置服务
  final isLocationServiceEnabledRx = false.obs;

  ///当前设备位置
  final locationRx = Rxn<Position>();

  final _debounceReport = Debouncer(delay: 1.seconds);

  @override
  void onInit() {
    super.onInit();
    Geolocator.isLocationServiceEnabled().then(isLocationServiceEnabledRx.call);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Geolocator.isLocationServiceEnabled()
          .then(isLocationServiceEnabledRx.call);
    }
  }

  ///上报用户当前位置到服务端
  ///- silent 静默上报（没有权限时，不进行申请）
  Future<void> reportPosition({bool silent = false}) async {
    //防抖处理
    return _debounceReport(()=> _reportPosition(silent: silent));
  }

  ///上报用户当前位置到服务端
  ///- silent 静默上报（没有权限时，不进行申请）
  Future<void> _reportPosition({bool silent = false}) async {
    if (!SS.login.isLogin) {
      return;
    }
    //检查权限
    var permission = await Geolocator.checkPermission();
    if (permission.isDenied && silent) {
      AppLogger.d('LocationService: silent=true, permission=$permission');
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission.isDenied) {
      AppLogger.d('LocationService: silent=$silent, permission=$permission');
      return;
    }

    //获取上次位置信息
    var position = await getLastKnownPosition();
    if (position != null) {
      AppLogger.d('LocationService: 上报上次的位置 $position');
      _reportDevicePosition(position);
    }

    //获取最新位置信息
    position = await getCurrentPosition(isRequestPermission: false);
    if(position != null){
      await _reportDevicePosition(position);
    }
  }

  Future<void> _reportDevicePosition(Position position) async {
    AppLogger.d('LocationService: _reportDevicePosition, position=$position');
    await UserApi.updateAccountPosition(
      longitude: position.longitude.toString(),
      latitude: position.latitude.toString(),
    );
  }

  ///请求定位权限
  Future<bool> requestPermission() async {
    // final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   ConfirmDialog.alert(message: const Text('位置服务未启用'));
    //   return false;
    // }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (permission.isDenied) {
      //   final result = await ConfirmDialog.show(
      //     message: Text('需要同意权限才可以使用该功能'),
      //     okButtonText: Text('前往设置'),
      //   );
      //   if (result) {
      //     Future.delayed(const Duration(milliseconds: 300), openAppSettings);
      //   }
      // }
    }
    return permission.isGranted;
  }

  ///获取最新位置信息
  ///- timeLimit 超时时间
  ///- isRequestPermission 是否请求定位权限
  Future<Position?> getCurrentPosition({
    Duration timeLimit = const Duration(minutes: 5),
    bool isRequestPermission = true,
  }) async {
    try {

      if(isRequestPermission){
        final isGranted = await requestPermission();
        if(!isGranted){
          return null;
        }
      }
      locationRx.value =
          await Geolocator.getCurrentPosition(timeLimit: timeLimit);
      return locationRx();
    } catch (ex) {
      AppLogger.d('LocationService: getCurrentPosition error: $ex');
      return null;
    }
  }

  ///获取最后一次已知位置信息
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (ex) {
      AppLogger.w(ex);
    }
    return null;
  }

}

extension on LocationPermission {
  ///已拒绝
  bool get isDenied => [
        LocationPermission.denied,
        LocationPermission.deniedForever
      ].contains(this);

  ///已授权
  bool get isGranted =>
      [LocationPermission.whileInUse, LocationPermission.always].contains(this);
}
