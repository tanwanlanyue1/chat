part of 'chat_manager.dart';

mixin ChatCallMixin {

  ///开始音视频通话
  Future<void> startCall({
    required int userId,
    required String nickname,
    required String callId,
    required bool isVideoCall,
  }) async {

    if(!await checkPermission(isVideoCall)){
      return;
    }

    final callable = await _checkStatus();
    if (!callable) {
      return;
    }

    final canInvitingInCalling = ZegoUIKitPrebuiltCallInvitationService()
            .private
            .callInvitationConfig
            ?.canInvitingInCalling ??
        true;

    final timeoutSeconds = 60;
    final type = ZegoCallTypeExtension(
      isVideoCall
          ? ZegoCallInvitationType.videoCall
          : ZegoCallInvitationType.voiceCall,
    ).value;

    final invitee = ZegoUIKitUser(
      id: userId.toString(),
      name: nickname,
    );

    final customData = '';
    final resourceID = '';
    String? notificationTitle;
    String? notificationMessage;

    final data = ZegoCallInvitationSendRequestProtocol(
      callID: callId,
      invitees: [invitee],
      timeout: timeoutSeconds,
      customData: customData,
    ).toJson();

    final notificationConfig = ZegoNotificationConfig(
      resourceID: resourceID,
      title: getNotificationTitle(
        defaultTitle: notificationTitle,
        callees: [ZegoCallUser(invitee.id, invitee.name)],
        isVideoCall: isVideoCall,
        innerText: _innerText,
      ),
      message: getNotificationMessage(
        defaultMessage: notificationMessage,
        callees: [ZegoCallUser(invitee.id, invitee.name)],
        isVideoCall: isVideoCall,
        innerText: _innerText,
      ),
      voIPConfig: ZegoNotificationVoIPConfig(
        iOSVoIPHasVideo: isVideoCall,
      ),
    );

    final sendRequest = canInvitingInCalling
        ? ZegoUIKit().getSignalingPlugin().sendAdvanceInvitation(
              inviterID: ZegoUIKit().getLocalUser().id,
              inviterName: ZegoUIKit().getLocalUser().name,
              invitees: [invitee.id],
              timeout: timeoutSeconds,
              type: type,
              data: data,
              zegoNotificationConfig: notificationConfig,
            )
        : ZegoUIKit().getSignalingPlugin().sendInvitation(
              inviterID: ZegoUIKit().getLocalUser().id,
              inviterName: ZegoUIKit().getLocalUser().name,
              invitees: [invitee.id],
              timeout: timeoutSeconds,
              type: type,
              data: data,
              isAdvancedMode: canInvitingInCalling,
              zegoNotificationConfig: notificationConfig,
            );
    final result = await sendRequest;
    final code = result.error?.code ?? '';
    final message = result.error?.message ?? '';
    final invitationID = result.invitationID;
    final errorInvitees = result.errorInvitees.keys.toList();

    ZegoLoggerService.logInfo(
      'pressed, code:$code, message:$message, '
          'invitation id:$invitationID, error invitees:$errorInvitees',
      tag: 'call-invitation',
      subTag: 'components, send call button',
    );

    _pageManager?.onLocalSendInvitation(
      callID: callId,
      invitees: [invitee],
      invitationType: isVideoCall
          ? ZegoCallInvitationType.videoCall
          : ZegoCallInvitationType.voiceCall,
      customData: customData,
      code: code,
      message: message,
      invitationID: invitationID,
      errorInvitees: errorInvitees,
      localConfig: ZegoCallInvitationLocalParameter(
        resourceID: resourceID,
        notificationTitle: notificationTitle,
        notificationMessage: notificationMessage,
        timeoutSeconds: timeoutSeconds,
      ),
    );

    _requesting = false;

    ZegoLoggerService.logInfo(
      'pressed, finish request',
      tag: 'call-invitation',
      subTag: 'components, send call button',
    );

  }

  ZegoCallInvitationPageManager? get _pageManager =>
      ZegoCallInvitationInternalInstance.instance.pageManager;

  ZegoUIKitPrebuiltCallInvitationData? get _callInvitationConfig =>
      ZegoCallInvitationInternalInstance.instance.callInvitationData;

  ZegoCallInvitationInnerText? get _innerText =>
      _callInvitationConfig?.innerText;

  var _requesting = false;

  ///检查麦克风和相机权限
  Future<bool> checkPermission(bool isVideoCall) async{
    if (isVideoCall) {
      return await PermissionsUtils.requestPermissions([
        Permission.camera,
        Permission.microphone,
      ], hintText: '需要开启相机和麦克风权限');
    } else {
      return await PermissionsUtils.requestPermission(
        Permission.microphone,
        hintText: '需要开启麦克风权限',
      );
    }
  }

  ///检查当前状态是否可以发起通话申请
  Future<bool> _checkStatus() async {
    if (ZegoSignalingPluginConnectionState.connected !=
        ZegoUIKit().getSignalingPlugin().getConnectionState()) {
      ZegoLoggerService.logError(
        'signaling is not connected:${ZegoUIKit().getSignalingPlugin().getConnectionState()}, '
        'please call ZegoUIKitPrebuiltCallInvitationService.init with ZegoUIKitSignalingPlugin first',
        tag: 'call-invitation',
        subTag: 'components, send call button',
      );
      return false;
    }

    if (_requesting) {
      ZegoLoggerService.logError(
        'still in request',
        tag: 'call-invitation',
        subTag: 'components, send call button',
      );
      return false;
    }

    if (ZegoCallMiniOverlayMachine().isMinimizing) {
      ZegoLoggerService.logError(
        'is in minimizing now',
        tag: 'call-invitation',
        subTag: 'components, send call button',
      );
      return false;
    }

    final currentState =
        _pageManager?.callingMachine?.machine.current?.identifier ??
            CallingState.kIdle;
    if (CallingState.kIdle != currentState) {
      ZegoLoggerService.logError(
        'is in calling, $currentState',
        tag: 'call-invitation',
        subTag: 'components, send call button',
      );
      return false;
    }

    _requesting = true;
    ZegoLoggerService.logInfo(
      'start request',
      tag: 'call-invitation',
      subTag: 'components, send call button',
    );

    return true;
  }
}
