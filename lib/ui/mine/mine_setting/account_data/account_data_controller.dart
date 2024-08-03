import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
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

  late final TextEditingController nicknameController;
  late final TextEditingController signatureController;

  @override
  void onInit() {
    final userInfo = SS.login.info?.copyWith();

    final List<String>? idsList = userInfo != null
        ? userInfo.type.isUser
            ? userInfo.likeStyle?.split(',')
            : userInfo.style?.split(',')
        : null;

    SS.appConfig.configRx.value?.labels?.forEach((element) {
      state.labelItems.add(LabelItem(
        id: element.id,
        title: element.tag,
        selected: idsList?.contains(element.id.toString()) ?? false,
      ));
    });

    nicknameController = TextEditingController(text: userInfo?.nickname);
    signatureController = TextEditingController(text: userInfo?.signature);

    super.onInit();
  }

  @override
  void onClose() {
    nicknameController.dispose();
    signatureController.dispose();
    super.onClose();
  }

  void onTapSave() async {
    FocusScope.of(Get.context!).unfocus();

    final info = state.info?.value.copyWith();
    if (info == null) return;

    // 昵称
    info.nickname = nicknameController.text;

    // 风格
    final selectedIdString = state.labelItems
        .where((item) => item.selected)
        .map((item) => item.id.toString())
        .join(',');

    switch (info.type) {
      case UserType.user:
        if (selectedIdString.isNotEmpty) info.likeStyle = selectedIdString;
        break;
      case UserType.beauty:
      case UserType.agent:
        if (selectedIdString.isNotEmpty) info.style = selectedIdString;
        break;
    }

    // 个人简介
    info.signature = signatureController.text;

    // 下面两个属性需要进行绑定操作，保存不需要进行修改
    info.phone = null;
    info.email = null;

    final data = info.toJson();

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

    Loading.showToast(S.current.success);
  }

  void onTapPosition() {
    Loading.showToast("待定");
  }

  void onTapPhone() {
    Get.toNamed(AppRoutes.bindingPage);
  }

  void onTapEmail() {
    Get.toNamed(AppRoutes.bindingPage);
  }

  void onTapLikeGender(UserGender gender) {
    state.info?.update((val) {
      val?.likeSex = gender;
    });
  }

  void onChangeLikeAge(int likeAgeMin, int likeAgeMax) {
    state.info?.update((val) {
      val?.likeAgeMin = likeAgeMin;
      val?.likeAgeMax = likeAgeMax;
    });
  }

  void onTapOccupation(UserOccupation occupation, UserModel info) {
    state.info?.update((val) {
      info.type.isUser
          ? val?.likeOccupation = occupation
          : val?.occupation = occupation;
    });
  }

  void onTapLabel(LabelItem item) {
    item.selected = !item.selected;
    update();
  }

  void onTapGender() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [
          S.current.male,
          S.current.female,
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
