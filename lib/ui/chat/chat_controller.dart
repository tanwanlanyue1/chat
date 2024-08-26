import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/ui/mine/inapp_message/models/call_match_content.dart';
import 'package:guanjia/widgets/loading.dart';

import 'chat_state.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin, GetAutoDisposeMixin {
  final ChatState state = ChatState();
  late final tabController = TabController(length: 2, vsync: this);

  @override
  void onInit() {
    autoCancel(SS.inAppMessage.listen((p0) {
      if (p0.type != InAppMessageType.callMatch) return;
      final content = p0.callMatchContent;
      if (content == null) return;
      _addSpeedDating(content);
    }));

    state.speedDatingList.listen((p0) {
      if (p0.isEmpty) {
        state.callContent.value = null;
      } else {
        state.callContent.value = p0.first.content;
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    for (var element in state.speedDatingList) {
      element.clearTimer();
    }
    super.onClose();
  }

  void closeSpeedDatingDialog() {
    _clearFirstSpeedDating();
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

    _clearFirstSpeedDating();
  }

  void _clearFirstSpeedDating() {
    if (state.speedDatingList.isNotEmpty) {
      final res = state.speedDatingList.removeAt(0);
      res.clearTimer();
    }
  }

  void _addSpeedDating(CallMatchContent content) {
    if (state.speedDatingList.length >= state.speedDatingMaxCount) return;

    state.speedDatingList.add(SpeedDatingMessage(
      content: content,
      onFinish: () {
        _clearFirstSpeedDating();
      },
    ));
  }
}
