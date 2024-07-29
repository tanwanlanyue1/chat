import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/widgets/loading.dart';

import 'update_info_state.dart';

class UpdateInfoController extends GetxController {
  final UpdateInfoState state = UpdateInfoState();
  TextEditingController textController = TextEditingController();

  void textValueChange(String text) {
    state.canSave = text.isNotEmpty;
    update();
  }

  void onTapSave(int type) async {
    final infoType = type == 0 ? 1 : 3;
    final content = textController.text;

    Loading.show();
    final infoRes =
        await UserApi.modifyUserInfo(type: infoType, content: content);
    Loading.dismiss();

    if (!infoRes.isSuccess) {
      infoRes.showErrorMessage();
      return;
    }

    Loading.showToast("已提交审核");

    Get.back();
  }
}
