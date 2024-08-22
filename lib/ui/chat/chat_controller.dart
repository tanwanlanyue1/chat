import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/widgets/loading.dart';

import 'chat_state.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin, GetAutoDisposeMixin {
  final ChatState state = ChatState();
  late final tabController = TabController(length: 2, vsync: this);

  Timer? _timer;

  @override
  void onInit() {
    autoCancel(SS.inAppMessage.listen((p0) {
      if (p0.type != InAppMessageType.callMatch) return;
      final content = p0.callMatchContent;
      if (content == null) return;

      state.callContent.value = content;

      _timer = Timer(
          Duration(
              seconds: SS.appConfig.configRx.value?.matchingCountDown ?? 90),
          () {
        state.callContent.value = null;
      });
    }));

    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void closeSpeedDatingDialog() {
    state.callContent.value = null;
  }

  void onTapGrab() async {
    final content = state.callContent.value;
    if (content == null) return;
    Loading.show();
    final res = await IMApi.grabSpeedDating(
      orderId: content.orderId,
    );
    Loading.dismiss();
    if (!res.isSuccess) {
      res.showErrorMessage();
    }

    _timer?.cancel();
    state.callContent.value = null;
  }
}
