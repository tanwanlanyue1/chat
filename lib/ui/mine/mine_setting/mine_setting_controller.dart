import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/image_cache_utils.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_setting_state.dart';

class MineSettingController extends GetxController {
  final MineSettingState state = MineSettingState();

  final version = "".obs;

  final cacheSize = "".obs;

  void onTapSignOut() async {
    Loading.show();
    final res = await SS.login.signOut();
    Loading.dismiss();
    res.when(
        success: (_) {},
        failure: (errorMessage) {
          Loading.showToast(errorMessage);
        });
    Get.backToRoot();
  }

  void onTapClearCache() {
    ImageCacheUtils.clearAllCacheImage();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
  }

  @override
  void onInit() async {
    version.value = await AppInfo.getVersion();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();

    super.onInit();
  }
}
