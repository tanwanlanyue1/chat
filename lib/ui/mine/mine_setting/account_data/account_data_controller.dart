import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/label_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';
import 'account_data_state.dart';

class AccountDataController extends GetxController {
  final AccountDataState state = AccountDataState();
  final ImagePicker picker = ImagePicker();

  final loginService = SS.login;

  final signatureController = TextEditingController();

  @override
  void onInit() {
    final userInfo = SS.login.info?.copyWith();

    final idsList = userInfo?.likeStyle?.split(',');

    SS.appConfig.configRx.value?.labels?.forEach((element) {
      state.labelItems.add(LabelItem(
        id: element.id,
        title: element.tag,
        selected: idsList?.contains(element.id.toString()) ?? false,
      ));
    });

    super.onInit();
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }

  void onTapSave() async {
    Loading.show();
    final res = await UserApi.updateInfoFull(
      data: state.info?.toJson(),
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    // 更新本地缓存
    loginService.fetchMyInfo();

    Loading.showToast("成功");
  }

  void onTapJob() {}

  void onTapLabel(LabelItem item) {
    item.selected = !item.selected;
    update();
  }

  /// 选择图片或者拍照
  void selectCamera() {
    PhotoAndCameraBottomSheet.show(
        onUploadUrls: _updateHead, limit: 1, isCrop: true);
  }

  Future<void> selectSex() async {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: const [
          "男",
          "女",
        ],
        onTap: (index) async {
          UserGender gender = UserGender.valueForIndex(index);

          loginService.setInfo((val) {
            val?.gender = gender;
          });
        },
      ),
    );
  }

  Future<void> selectBirth(int year, int month, int day) async {
    final date = DateTime(year, month, day);
  }

  void _updateHead(List<String> urls) async {
    Loading.show();
    final infoRes = await UserApi.modifyUserInfo(type: 2, content: urls.first);
    Loading.dismiss();

    if (!infoRes.isSuccess) {
      infoRes.showErrorMessage();
      return;
    }

    Loading.showToast("成功");
  }
}
