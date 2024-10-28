import 'package:get/get.dart';
import 'package:guanjia/common/service/location_service.dart';
import 'ad_service.dart';
import 'app_config_service.dart';
import 'inapp_message_service.dart';
import 'login_service.dart';

class SS {
  SS._();
  // 入口保证初始化
  static Future<void> initServices() async {
    await Get.putAsync(() => LoginService().init());
    Get.put(AppConfigService());
    Get.put(InAppMessageService());
    Get.put(LocationService());
    Get.put(ADService());
  }

  static LoginService get login => Get.find<LoginService>();

  ///APP配置信息
  static AppConfigService get appConfig => Get.find<AppConfigService>();

  ///应用内消息服务
  static InAppMessageService get inAppMessage => Get.find<InAppMessageService>();

  ///位置服务
  static LocationService get location => Get.find<LocationService>();

  ///广告服务
  static ADService get ad => Get.find<ADService>();

}
