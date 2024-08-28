import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/image_gallery_utils.dart';
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
      onUploadUrls: _updateAvatar,
      onTapSave: _saveAvatar,
      limit: 1,
      isCrop: true,
      hasSave: true,
    );
  }

  void _saveAvatar() {
    ImageGalleryUtils.saveNetworkImage(avatar.value);
  }

  void _updateAvatar(List<String> urls) async {
    avatar.value = urls.first;
  }
}
