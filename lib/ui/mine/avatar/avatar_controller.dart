import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/image_gallery_utils.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';
import 'package:guanjia/widgets/widgets.dart';

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
    if(urls.isEmpty){
      return;
    }
    Loading.show();
    final res = await UserApi.updateInfoPartial(avatar: urls.first);
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    Loading.showToast('修改成功');
    avatar.value = urls.first;

    // 更新本地缓存
    SS.login.fetchMyInfo();
  }
}
