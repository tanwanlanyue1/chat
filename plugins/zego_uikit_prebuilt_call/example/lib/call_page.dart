// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'constants.dart';

class CallPage extends StatelessWidget {
  final String callID;

  const CallPage({
    Key? key,
    required this.callID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 1111 /*input your AppID*/,
        appSign: 'yourAppSign' /*input your AppSign*/,
        userID: localUserID,
        userName: "user_$localUserID",
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          // ..onOnlySelfInRoom = (context) {
          //   if (PrebuiltCallMiniOverlayPageState.idle !=
          //       ZegoUIKitPrebuiltCallMiniOverlayMachine().state()) {
          //     /// now is minimizing state, not need to navigate
          //     ZegoUIKitPrebuiltCallMiniOverlayMachine().switchToIdle();
          //   } else {
          //     Navigator.of(context).pop();
          //   }
          // }

          /// support minimizing
          ..topMenuBarConfig.isVisible = true
          ..topMenuBarConfig.buttons = [
            ZegoMenuBarButtonName.minimizingButton,
            ZegoMenuBarButtonName.showMemberListButton,
          ],
      ),
    );
  }
}
