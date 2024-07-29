import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';

import 'record_details_state.dart';

class RecordDetailsController extends GetxController {
  RecordDetailsController({
    required this.info,
  }) : isAdd = info == null;

  // 档案信息
  ArchivesInfo? info;

  // 是否是新建档案
  final bool isAdd;

  final RecordDetailsState state = RecordDetailsState();

  late TextEditingController nickController;

  final ImagePicker picker = ImagePicker();

  /// 选择图片或者拍照
  void selectCamera() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: const ["相册", "拍摄"],
        onTap: (index) async {
          final isPhoto = index == 0;

          if (GetPlatform.isIOS) {
            final isGranted = isPhoto
                ? await PermissionsUtils.requestPhotosPermission()
                : await PermissionsUtils.requestCameraPermission();
            if (!isGranted) return;
          }

          final image = await picker.pickImage(
            source: isPhoto ? ImageSource.gallery : ImageSource.camera,
          );

          if (image == null) return;

          Loading.show();
          final res = await UserApi.upload(filePath: image.path);
          Loading.dismiss();

          if (!res.isSuccess) {
            res.showErrorMessage();
            return;
          }

          final url = res.data;
          if (url == null || url.isEmpty) {
            Loading.showToast("上传资源发生错误");
            return;
          }

          info?.avatar = url;
          update();
        },
      ),
    );
  }

  void onSelectSex(bool isMan) {
    info?.sex = isMan ? 0 : 1;
    update();
  }

  void onChangeNick(String nick) {
    info?.nickname = nick;
  }

  void onSelectBirthDate(List<String> value) {
    if (value.length < 4) return;

    final time = "${value[0]}年${value[1]}月${value[2]}日 ${value[3]}时";
    info?.birth = time;
    update();
  }

  void onSelectAddress(String p, String c, String t) {
    info?.currentResidence = "$p$c$t";
    update();
  }

  void onTapCommit() async {
    Loading.show();
    final res = await UserApi.addOrModifyArchive(
      id: info?.id,
      sex: info?.sex ?? 0,
      avatar: info?.avatar,
      nickname: info?.nickname,
      label: info?.label,
      birth: info?.birth,
      birthPlace: info?.birthPlace,
      currentResidence: info?.currentResidence,
      timeZone: info?.timeZone,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    Get.back(result: true);
  }

  @override
  void onInit() {
    info ??= ArchivesInfo();

    nickController = TextEditingController(text: info?.nickname ?? "");

    super.onInit();
  }

  @override
  void onClose() {
    nickController.dispose();
    super.onClose();
  }
}
