import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/widgets/loading.dart';

import 'speed_dating_state.dart';

class SpeedDatingController extends GetxController
    with GetAutoDisposeMixin, GetTickerProviderStateMixin {
  final SpeedDatingState state = SpeedDatingState();

  Timer? _timer;
  Timer? _endTimer;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  Future<void> onInit() async {
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    autoCancel(SS.inAppMessage.listen((p0) {
      if (p0.type != InAppMessageType.callMatchSuccess) return;
      final content = p0.callMatchContent;
      if (content == null) return;

      state.isAnimation.value = false;

      ChatManager().startCall(
        userId: content.uid,
        nickname: content.nickname,
        callId: content.orderId.toString(),
        isVideoCall: content.isVideo,
        autoAccept: true,
      );
    }));

    autoCancel(state.isAnimation.listen((p0) {
      if (p0) {
        animationController.repeat();
        _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
          final index = state.avatarIndex.value;

          if (index + 5 >= state.avatars.length - 1) {
            state.avatarIndex.value = 0;
          } else {
            state.avatarIndex.value = index + 5;
          }
        });

        final countDown = SS.appConfig.configRx.value?.matchingCountDown ?? 90;
        _endTimer = Timer(Duration(seconds: countDown), () {
          state.isAnimation.value = false;
        });
      } else {
        animationController.reset();
        animationController.stop();
        _timer?.cancel();
        _endTimer?.cancel();
      }
    }));

    final res = await UserApi.recommendList();
    if (res.isSuccess && res.data != null) {
      final list = res.data!.map((e) => e.avatar ?? "").toList();
      List<String> newList = [];

      final count = state.roundCount;

      if (list.length % count == 0) {
        if (list.isEmpty) {
          for (int i = 0; i < count; i++) {
            newList.add("");
          }
        } else {
          newList.addAll(list);
        }
      } else {
        for (String element in list) {
          for (int i = 0; i < count; i++) {
            newList.add(element);
          }
        }
      }
      state.avatars = newList;
    }

    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _endTimer?.cancel();
    super.onClose();
  }

  // 点击开启速配
  void onTapStart(bool isVideo) async {
    state.roundCount = isVideo ? 5 : 1;
    if (state.isAnimation.value) return;

    Loading.show();
    final res = await IMApi.startSpeedDating(type: isVideo ? 1 : 2);
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    state.isAnimation.value = true;
  }
}
