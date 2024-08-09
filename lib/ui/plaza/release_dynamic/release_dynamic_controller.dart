import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/ui/plaza/widgets/publish_success.dart';

import '../../../common/network/api/api.dart';
import 'release_dynamic_state.dart';

class ReleaseDynamicController extends GetxController with GetSingleTickerProviderStateMixin {
  final ReleaseDynamicState state = ReleaseDynamicState();
  TextEditingController contentController = TextEditingController(); //帖子内容

  @override
  void onInit() {
    super.onInit();
  }


  ///发布帖子
  void addCommunity() async {
    final response = await PlazaApi.addCommunity(
        content: contentController.text,
        images: jsonEncode(state.imgList)
    );
    if (response.isSuccess) {
      EventBus().emit(kEventInvitationSuccess);
      PublishSuccess.show();
    } else {
      response.showErrorMessage();
    }
  }

}
