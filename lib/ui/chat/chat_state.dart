import 'dart:async';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/inapp_message/models/call_match_content.dart';

class ChatState {
  final callContent = Rxn<CallMatchContent>();

  final speedDatingList = <SpeedDatingMessage>[].obs;

  /// 匹配对话弹窗最大数量
  final int speedDatingMaxCount = 5;
}

class SpeedDatingMessage {
  final CallMatchContent content;

  final Function? onFinish;

  late Timer _timer;

  int countDown = SS.appConfig.configRx.value?.matchingCountDown ?? 90;

  SpeedDatingMessage({
    required this.content,
    this.onFinish,
  }) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("-----countDown: $countDown, id: ${identityHashCode(this)}");
      countDown = countDown - 1;
      if (countDown <= 0) {
        timer.cancel();
        onFinish?.call();
      }
    });
  }

  void clearTimer() {
    _timer.cancel();
  }
}
