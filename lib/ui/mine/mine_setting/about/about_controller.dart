import 'package:get/get.dart';
import 'package:guanjia/common/utils/app_info.dart';

import 'about_state.dart';

class AboutController extends GetxController {
  final AboutState state = AboutState();

  @override
  void onInit() async {
    state.version.value = await AppInfo.getVersion();

    state.appName.value = await AppInfo.getAppName();

    super.onInit();
  }
}
