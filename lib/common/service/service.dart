import 'package:get/get.dart';
import 'app_config_service.dart';
import 'login_service.dart';

class SS {
  SS._();
  // 入口保证初始化
  static Future<void> initServices() async {
    await Get.putAsync(() => LoginService().init());
    Get.put(AppConfigService());
  }

  static LoginService get login => Get.find<LoginService>();

  static AppConfigService get appConfig => Get.find<AppConfigService>();

}
