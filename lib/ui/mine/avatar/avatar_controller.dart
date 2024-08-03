import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';

class AvatarController extends GetxController {

  final avatar = "".obs;

  @override
  void onInit() {
    final info = SS.login.info;
    if (info != null) {
      avatar.value = info.avatar ?? "";
    }

    super.onInit();
  }

  void onTapMore() {
    PhotoAndCameraBottomSheet.show(
        onUploadUrls: _updateAvatar, limit: 1, isCrop: true);
  }

  void _updateAvatar(List<String> urls) async {
    avatar.value = urls.first;
  }
}
