// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_uikit/zego_uikit.dart';

class ZegoScreenSharingViewController {
  final _fullscreenUserNotifier = ValueNotifier<ZegoUIKitUser?>(null);

  ValueNotifier<ZegoUIKitUser?> get fullscreenUserNotifier =>
      _fullscreenUserNotifier;

  /// This function is used to specify whether a certain user enters or exits full-screen mode during screen sharing.
  ///
  /// You need to provide the user's ID [userID] to determine which user to perform the operation on.
  /// By using a boolean value [isFullscreen], you can specify whether the user enters or exits full-screen mode.
  void showScreenSharingViewInFullscreenMode(String userID, bool isFullscreen) {
    _fullscreenUserNotifier.value =
        isFullscreen ? ZegoUIKit().getUser(userID) : null;
  }
}
