import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/widgets/loading.dart';

import 'speed_dating_state.dart';

class SpeedDatingController extends GetxController
    with GetAutoDisposeMixin {
  final SpeedDatingState state = SpeedDatingState();

  @override
  void onInit() {
    autoCancel(SS.inAppMessage.listen((p0) {
      if (p0.type != InAppMessageType.callMatchSuccess) return;
      final content = p0.callMatchContent;
      if (content == null) return;

      ChatManager().startCall(
        userId: content.uid,
        nickname: content.nickname,
        callId: content.orderId.toString(),
        isVideoCall: content.isVideo,
        autoAccept: true,
      );
    }));

    super.onInit();
  }

  // 点击开启速配
  void onTapStart(bool isVideo) async {
    Loading.show();
    final res = await IMApi.startSpeedDating(type: isVideo ? 1 : 2);
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
  }
}
