import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/list_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_feedback_state.dart';

class MineFeedbackController extends GetxController {
  final MineFeedbackState state = MineFeedbackState();

  FocusNode focusNode = FocusNode();

  TextEditingController contentController = TextEditingController(); //问题控制器
  TextEditingController contactController = TextEditingController(); //联系方式控制器


  void submit() async {
    final content = contentController.text;
    if (content.isEmpty) {
      Loading.showToast("问题与意见不能为空");
      return;
    }

    final type = state.typeList.safeElementAt(state.typeIndex)?["type"] ?? 6;

    Loading.show();
    final images = jsonEncode(state.imgList);
    final res = await UserApi.feedback(
      type: type,
      content: content,
      contact: contactController.text,
      images: images,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    Loading.showToast("提交成功");

    Get.back();
  }

  @override
  void onClose() {
    contentController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
