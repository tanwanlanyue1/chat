import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/user/area_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/label_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'account_data_state.dart';

class AccountDataController extends GetxController with GetAutoDisposeMixin {
  final AccountDataState state = AccountDataState();
  final ImagePicker picker = ImagePicker();

  final loginService = SS.login;

  final userType = SS.login.info?.type ?? UserType.user;

  late final TextEditingController nicknameController;
  late final TextEditingController signatureController;

  @override
  void onInit() {
    final userInfo = loginService.info;
    nicknameController = TextEditingController(text: userInfo?.nickname);
    signatureController = TextEditingController(text: userInfo?.signature);

    _getLabelList();

    //监听地区选择
    autoDisposeWorker(EventBus().listen(kEventChooseArea, (data) {
      if(data is List<AreaModel>){
        final position = data.map((e) => e.name).join(' ');
        state.info?.update((val) {
          val?.position = position;
        });
      }
    }));

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
        info.likeStyle = selectedIdString;
        break;
      case UserType.beauty:
      case UserType.agent:
        info.style = selectedIdString;
        break;
    }

    // 个人简介
    info.signature = signatureController.text;

    // 下面两个属性需要进行绑定操作，保存不需要进行修改
    info.phone = null;
    info.email = null;

    // 头像在头像上传也已经保存，这里的保存不需要进行修改
    info.avatar = null;

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

    Loading.showToast(S.current.saveSuccessfully);
    Get.back();
  }

  ///地区
  void onTapArea() {
    Get.toNamed(AppRoutes.chooseAreaPage, arguments: {"currentIndex": 0});
  }

  void onTapPhone() {
    Get.toNamed(AppRoutes.bindingPage, arguments: {"currentIndex": 0});
  }

  void onTapEmail() {
    Get.toNamed(AppRoutes.bindingPage, arguments: {"currentIndex": 1});
  }

  void onTapLikeGender(UserGender gender) {
    state.info?.update((val) {
      val?.likeSex = gender;
      _getLabelList();
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
            if (userType.isBeauty) _getLabelList();
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

  void onTapAvatar() {
    Get.toNamed(AppRoutes.avatarPage);
  }

  void _getLabelList() {
    final userInfo = loginService.info;
    if (userInfo == null) return;

    final UserGender gender;

    switch (userType) {
      case UserType.user:
        gender = state.info?.value.likeSex ?? UserGender.unknown;
        break;
      case UserType.beauty:
        gender = state.info?.value.gender ?? UserGender.unknown;
      case UserType.agent:
        gender = UserGender.unknown;
    }

    state.labelItems.clear();

    final config = SS.appConfig.configRx.value;
    if (config != null) {
      final List<String>? idsList = userType == UserType.user
          ? userInfo.likeStyle?.split(',')
          : userInfo.style?.split(',');

      final List<LabelModel> list;

      switch (gender) {
        case UserGender.male:
          list = config.maleStyleList;
          break;
        case UserGender.female:
          list = config.femaleStyleList;
          break;
        case UserGender.unknown:
          list = config.commonStyleList;
          break;
      }
      for (var element in list) {
        state.labelItems.add(LabelItem(
          id: element.id,
          title: element.tag,
          icon: element.icon,
          selected: idsList?.contains(element.id.toString()) ?? false,
        ));
      }
    }

    update();
  }
}
