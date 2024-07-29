import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/lunar/lunar_view.dart';

import 'lights_pray_invitation_state.dart';

class LightsPrayInvitationController extends GetxController {
  final LightsPrayInvitationState state = LightsPrayInvitationState();

  TextEditingController nameController = TextEditingController();

  final FocusNode contentFocusNode = FocusNode();

  TextEditingController contentController = TextEditingController();

  final loginService = SS.login;

  void onChangeSelect(int index) {
    state.selectIndex.value = index;
  }

  void onChangeOpen() {
    state.isOpen.value = !state.isOpen.value;
  }

  void onTapInvitation({required int position, required int direction}) async {
    loginService.requiredAuthorized(() async {
      if (nameController.text.isEmpty) {
        Loading.showToast("请输入您的真实姓名");
        return;
      }

      if (state.birthday.isEmpty) {
        Loading.showToast("请选择您的生辰");
        return;
      }

      final content = contentController.text.isEmpty
          ? state.defaultContent
          : contentController.text;

      final res = await LightsPrayApi.invite(
        giftId: state.lights[state.selectIndex.value].id,
        name: nameController.text,
        birthday: state.birthday.value,
        back: content,
        position: position,
        direction: direction,
        open: state.isOpen.value ? 0 : 1,
      );

      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      SS.login.fetchLevelMoneyInfo();

      Get.back(result: position);
    });
  }

  void onTapChooseBirth() {
    LunarView.show(
      onSelectionChanged: (List<String> value) {
        if (value.length < 4) return;

        state.birthday.value =
            "${value[0]}年${value[1]}月${value[2]}日 ${value[3]}时";
      },
    );
  }

  Future<void> fetchLights() async {
    final res = await GiftApi.list(type: 5);
    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    state.lights.value = res.data!;
  }

  @override
  void onInit() async {
    Loading.show();
    await fetchLights();
    Loading.dismiss();
    super.onReady();
  }

  @override
  void onClose() {
    contentFocusNode.dispose();
    nameController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
