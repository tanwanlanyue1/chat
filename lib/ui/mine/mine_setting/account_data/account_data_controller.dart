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

  late final TextEditingController signatureController;

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

    signatureController = TextEditingController(text: userInfo?.signature);

    super.onInit();
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }

  void onTapSave() async {
    final info = state.info?.value;
    if (info == null) return;

    final data = info.toJson();

    // 风格
    final selectedIdString = state.labelItems
        .where((item) => item.selected)
        .map((item) => item.id.toString())
        .join(',');

    switch (info.type) {
      case UserType.user:
        if (selectedIdString.isNotEmpty) data["likeStyle"] = selectedIdString;
        break;
      case UserType.beauty:
      case UserType.agent:
        if (selectedIdString.isNotEmpty) data["style"] = selectedIdString;
        break;
    }

    // 个人简介
    data["signature"] = signatureController.text;

    Loading.show();
    final res = await UserApi.updateInfoFull(
      data: data,
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

  void onTapGender() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: const [
          "男",
          "女",
        ],
        onTap: (index) async {
          final UserGender gender;
          switch (index) {
            case 0:
              gender = UserGender.male;
              break;
            case 1:
              gender = UserGender.female;
              break;
            default:
              gender = UserGender.unknown;
              return;
          }

          state.info?.update((val) {
            val?.gender = gender;
          });
        },
      ),
    );
  }

  void onConfirmAge(int age) {
    state.info?.update((val) {
      val?.age = age;
    });
  }

  void onTapHeader() {
    PhotoAndCameraBottomSheet.show(
        onUploadUrls: _updateHead, limit: 1, isCrop: true);
  }

  void _updateHead(List<String> urls) async {
    state.info?.update((val) {
      val?.avatar = urls.first;
    });
  }
}
