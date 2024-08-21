part of 'chat_manager.dart';

mixin ChatCallMixin {

  ///当前通话ID（对应业务服务端订单id）
  var _callId = '';

  ///当前通话发起方用户ID
  var _callInviter = '';

  ///当前通话接收方用户ID
  var _callInvitee = '';

  ///最后一次通话扣费的分钟数
  var _callPayInMinutes = -1;

  ///开始音视频通话
  Future<void> startCall({
    required int userId,
    required String nickname,
    required String callId,
    required bool isVideoCall,
  }) async {
    if (!await checkPermission(isVideoCall)) {
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

    print('canInvitingInCalling: $canInvitingInCalling');

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

  ///挂断通话
  Future<bool> hangUp(){
    return ZegoUIKitPrebuiltCallInvitationService().controller.hangUp(Get.context!);
  }

  ZegoCallInvitationPageManager? get _pageManager =>
      ZegoCallInvitationInternalInstance.instance.pageManager;

  ZegoUIKitPrebuiltCallInvitationData? get _callInvitationConfig =>
      ZegoCallInvitationInternalInstance.instance.callInvitationData;

  ZegoCallInvitationInnerText? get _innerText =>
      _callInvitationConfig?.innerText;

  var _requesting = false;

  ///检查麦克风和相机权限
  Future<bool> checkPermission(bool isVideoCall) async {
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

  ///初始化音视频通话服务
  Future<void> _initChatCall({
    required String userId,
    required String nickname,
  }) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConfig.zegoAppId,
      appSign: AppConfig.zegoAppSign,
      userID: userId,
      userName: nickname,
      plugins: [ZegoUIKitSignalingPlugin()],
      //自定义文本内容
      innerText: ZegoCallInvitationInnerText(),
      requireConfig: _requireCallConfig,
      config: ZegoCallInvitationConfig(
        endCallWhenInitiatorLeave: false,
        canInvitingInCalling: false,
        permissions: [],
      ),
      uiConfig: _callInvitationUIConfig(),
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (ZegoCallEndEvent event, VoidCallback defaultAction) {
          defaultAction.call();
          AppLogger.d(
              'ZegoUIKitPrebuiltCallEvents>onCallEnd reason=, ${event.reason}');
          _clearCallState();
        },
      ),
      //事件说明 https://www.zegocloud.com/docs/uikit/zh/callkit-android/api-reference/event#invitationevents
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (
          String callID,
          ZegoCallUser callee,
        ) {
          AppLogger.d(
              'ZegoUIKitPrebuiltCallInvitationEvents>onOutgoingCallAccepted: callID=${callID}');
          _clearCallState();
          _callId = callID;
          _callInvitee = callee.id;
          _callInviter = ZegoUIKit().getLocalUser().id;
          _isWaitCallEndDialog = true;
        },
        onIncomingCallReceived: (
          String callID,
          ZegoCallUser caller,
          ZegoCallInvitationType callType,
          List<ZegoCallUser> callees,
          String customData,
        ) {
          _isWaitCallEndDialog = true;
        },
        onOutgoingCallRejectedCauseBusy: (
          String callID,
          ZegoCallUser callee,
          String customData,
        ) {
          Loading.showToast('对方正在通话中');
        },
      ),
    );
  }

  ///音视频通话呼叫过程中的UI配置
  ZegoCallInvitationUIConfig _callInvitationUIConfig() {
    //背景
    Widget? backgroundBuilder(
      BuildContext context,
      Size size,
      ZegoCallingBuilderInfo info,
    ) {
      return AppImage.asset(
        width: size.width,
        height: size.height,
        'assets/images/chat/call_background.png',
        fit: BoxFit.cover,
      );
    }

    return ZegoCallInvitationUIConfig(
      prebuiltWithSafeArea: false,
      invitationWithSafeArea: false,
      systemUiOverlayStyle: SystemUiOverlayStyle.light,
      //邀请人
      inviter: ZegoCallInvitationInviterUIConfig(
        backgroundBuilder: backgroundBuilder,
      ),
      //被邀请人
      invitee: ZegoCallInvitationInviteeUIConfig(
        backgroundBuilder: backgroundBuilder,
      ),
    );
  }

  ///音视频通话配置
  ZegoUIKitPrebuiltCallConfig _requireCallConfig(ZegoCallInvitationData data) {
    final isVideoCall = ZegoCallInvitationType.videoCall == data.type;
    final config = (data.invitees.length > 1)
        ? isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
        : isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

    //用户头像配置
    config.avatarBuilder = (
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map extraInfo,
    ) {
      return ChatAvatar.circle(
        userId: user?.id ?? '',
        width: size.width,
        height: size.height,
      );
    };

    //底部菜单栏配置
    config.bottomMenuBar = ZegoCallBottomMenuBarConfig(
      hideAutomatically: false,
      margin: const EdgeInsets.only(bottom: 48),
      buttons: [
        if (isVideoCall) ZegoCallMenuBarButtonName.toggleCameraButton,
        ZegoCallMenuBarButtonName.toggleMicrophoneButton,
        ZegoCallMenuBarButtonName.hangUpButton,
        ZegoCallMenuBarButtonName.switchAudioOutputButton,
        if (isVideoCall) ZegoCallMenuBarButtonName.switchCameraButton,
      ],
    );

    //布局配置
    config.audioVideoView = ZegoCallAudioVideoViewConfig(
        //是否在视图上显示麦克风状态。默认显示
        showMicrophoneStateOnView: false,
        //是否在视图上显示摄像头状态。默认显示
        showCameraStateOnView: false,
        //是否在视图上显示用户名。默认显示。
        showUserNameOnView: false,
        //是否裁剪视频，填充整个屏幕
        useVideoViewAspectFill: true,
        //通话界面背景
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return AppImage.asset(
            width: size.width,
            height: size.height,
            'assets/images/chat/call_background.png',
            fit: BoxFit.cover,
          );
        });

    //画中画布局
    config.layout = ZegoLayoutPictureInPictureConfig(
      isSmallViewShowOnlyVideo: true,
      margin: EdgeInsets.only(
        top: Get.mediaQuery.padding.top + 44.rpx,
        right: 16.rpx,
      ),
    );

    //通话时长回调
    config.duration = ZegoCallDurationConfig(onDurationUpdate: (duration) {
      _callingPay(duration);
    });

    return config;
  }

  ///显示通话结束对话框
  var _isWaitCallEndDialog = false;

  void _showCallEndDialog(ZIMKitMessage message) {
    final callEndContent = message.callEndContent;
    if (callEndContent == null || !_isWaitCallEndDialog) {
      return;
    }
    _isWaitCallEndDialog = false;
    Future.delayed(const Duration(milliseconds: 400), () {
      ChatCallEndDialog.show(message: message);
    });
  }

  ///通话计费
  Future<void> _callingPay(Duration duration) async{
    AppLogger.d('_callingPay: _callId=$_callId, _callInviter=$_callInviter, _callPayInMinutes=$_callPayInMinutes, duration=$duration');

    //发起方扣费
    if(_callId.isEmpty || _callInviter != SS.login.userId.toString()){
      return;
    }
    //每分钟调一次接口进行扣费
    final inMinutes = duration.inMinutes;
    if(inMinutes <= _callPayInMinutes){
      return;
    }
    final orderId = int.tryParse(_callId);
    if(orderId == null){
      hangUp();
      AppLogger.w('订单ID解析失败，无法扣费');
      return;
    }

    _callPayInMinutes = inMinutes;
    final response = await IMApi.chatOrderPay(orderId);
    if(response.isSuccess){
      AppLogger.d('扣费成功');
    }else{
      hangUp();
      AppLogger.w('扣费失败，挂断通话');
    }
  }

  void _clearCallState(){
    _callId = '';
    _callInviter = '';
    _callInvitee = '';
    _callPayInMinutes = -1;
  }

  Future<void> _uninitChatCall() async{
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _clearCallState();
    _isWaitCallEndDialog = false;
  }

}
