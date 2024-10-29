import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/widgets/loading.dart';

import 'speed_dating_state.dart';

class SpeedDatingController extends GetxController
    with GetAutoDisposeMixin, GetTickerProviderStateMixin {
  final SpeedDatingState state = SpeedDatingState();

  final _duration = const Duration(seconds: 3);

  Timer? _timer;
  Timer? _endTimer;
  final bool isVideo;

  late AnimationController animationController;
  final animations = <Animation<double>>[];

  SpeedDatingController({required this.isVideo});

  @override
  Future<void> onInit() async {
    state.roundCount = isVideo ? 5 : 1;
    animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );
    List.generate(5, (index) {
      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(index * 0.2, index * 0.2 + 0.2),
        ),
      );
      animations.add(animation);
    });

    autoCancel(SS.inAppMessage.listen((event) {
      if (event.type != InAppMessageType.callMatchSuccess) return;
      final content = event.callMatchContent;
      if (content == null) return;

      state.isAnimation.value = false;

      ChatManager().startCall(
        userId: content.uid,
        nickname: content.nickname,
        callId: content.orderId.toString(),
        isVideoCall: content.isVideo,
        autoAccept: true,
        enableCamera: state.isCameraOpen.value,
      );
    }));

    autoCancel(state.isAnimation.listen((value) {
      if (value) {
        animationController.repeat();
        _timer = Timer.periodic(_duration, (timer) {
          if(isVideo){
            _refreshAvatars();
          }else{
            final index = state.avatarIndex.value;
            if (index + state.roundCount > state.allAvatars.length - 1) {
              state.avatarIndex.value = 0;
            } else {
              state.avatarIndex.value = index + state.roundCount;
            }
          }
        });

        final countDown = SS.appConfig.configRx.value?.matchingCountDown ?? 90;
        _endTimer = Timer(Duration(seconds: countDown), () {
          Loading.showToast(S.current.waitTimeoutTryAgain);
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
      final roundCount = state.roundCount;
      final mod = list.length % roundCount;
      if (mod == 0) {
        if (list.isEmpty) {
          for (int i = 0; i < roundCount; i++) {
            newList.add("");
          }
        } else {
          newList.addAll(list);
        }
      } else {
        newList.addAll(list);
        newList.addAll(list.take(mod));
      }
      state.allAvatars = newList;
      _refreshAvatars();
    }

    super.onInit();
  }

  void _refreshAvatars(){
    final allAvatars = state.allAvatars;
    if(allAvatars.isEmpty){
      return;
    }
    if(allAvatars.length <= state.roundCount){
      if(state.avatarsRx.isEmpty){
        state.avatarsRx.addAll(allAvatars);
      }
      return;
    }

    var skip = state.avatarIndex() * state.roundCount;
    var items = allAvatars.skip(skip).take(state.roundCount);
    if(items.isEmpty){
      items = allAvatars.take(state.roundCount);
      state.avatarIndex.value = 0;
    }else{
      state.avatarIndex.value++;
    }
    state.avatarsRx..clear()..addAll(items);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _endTimer?.cancel();
    super.onClose();
  }

  // 点击开启速配
  void onTapStart() async {
    // 在动画中证明要进行取消操作
    if (state.isAnimation.value) {
      Loading.show();
      final res = await IMApi.cancelSpeedDating(orderId: state.orderId);
      Loading.dismiss();

      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      state.isAnimation.value = false;
    } else {
      Loading.show();
      final res = await IMApi.startSpeedDating(type: isVideo ? 1 : 2);
      Loading.dismiss();

      if (!res.isSuccess) {
        res.showErrorMessage();
        return;
      }

      state.orderId = res.data ?? 0;

      state.isAnimation.value = true;
    }
  }
}
