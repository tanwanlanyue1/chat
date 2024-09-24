part of 'chat_manager.dart';

mixin _ChatCallMixin {
  ///当前通话ID（对应业务服务端订单id）
  var _callId = '';

  ///是否是视频通话
  var _isVideoCall = false;

  ///当前通话发起方用户ID
  var _callInviter = '';

  ///当前通话接收方用户ID
  var _callInvitee = '';

  ///最后一次通话扣费时间
  DateTime? _callPayTime;

  ///扣费UUID
  String? _callPayUuid;

  ///是否需要再次显示充值提醒对话框
  var _callRechargeDialogAgain = true;

  ///开始音视频通话
  ///- userId 接收方用户ID
  ///- nickname 接收方昵称
  ///- callId 通话ID（对应业务订单ID）
  ///- isVideoCall 是否是视频通话
  ///- enableCamera 是否默认启用摄像头(仅视频通话有效)
  ///- autoAccept 接收方是否自动接听
  Future<void> startCall({
    required int userId,
    required String nickname,
    required String callId,
    required bool isVideoCall,
    bool enableCamera = true,
    bool autoAccept = false,
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

    const timeoutSeconds = 60;
    final type = ZegoCallTypeExtension(
      isVideoCall
          ? ZegoCallInvitationType.videoCall
          : ZegoCallInvitationType.voiceCall,
    ).value;

    final invitee = ZegoUIKitUser(
      id: userId.toString(),
      name: nickname,
    );

    final customData = CallCustomData(autoAccept, enableCamera).toJsonString();
    String? notificationTitle;
    String? notificationMessage;

    final data = ZegoCallInvitationSendRequestProtocol(
      callID: callId,
      invitees: [invitee],
      timeout: timeoutSeconds,
      customData: customData,
    ).toJson();

    final notificationConfig = ZegoNotificationConfig(
      resourceID: AppConfig.zegoCallResourceId,
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
        resourceID: AppConfig.zegoCallResourceId,
        notificationTitle: notificationTitle,
        notificationMessage: notificationMessage,
        timeoutSeconds: timeoutSeconds,
      ),
    );

    _clearCallState();
    _callId = callId;
    _isVideoCall = isVideoCall;
    _callInvitee = invitee.id;
    _callInviter = ZegoUIKit().getLocalUser().id;

    _requesting = false;

    ZegoLoggerService.logInfo(
      'pressed, finish request',
      tag: 'call-invitation',
      subTag: 'components, send call button',
    );
  }

  ///挂断通话
  Future<bool> hangUpCall() {
    return ZegoUIKitPrebuiltCallInvitationService()
        .controller
        .hangUp(Get.context!);
  }

  ///接听通话
  Future<bool> acceptCall({String? customData}) {
    return ZegoUIKitPrebuiltCallInvitationService()
        .accept(customData: customData ?? '');
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
      ], hintText: S.current.cameraMicrophoneNeed);
    } else {
      return await PermissionsUtils.requestPermission(
        Permission.microphone,
        hintText: S.current.needsMicrophonePermission,
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
      innerText: ZegoCallInvitationInnerText(
        incomingVideoCallDialogMessage: S.current.videoChatCallIn,
        incomingVoiceCallDialogMessage: S.current.voiceChatCallIn,
        incomingVideoCallPageMessage: S.current.videoChatCallIn,
        incomingVoiceCallPageMessage: S.current.voiceChatCallIn,
        incomingCallPageDeclineButton: '',
        incomingCallPageAcceptButton: '',
        incomingCallVoIPDeclineButton: S.current.hangUp,
        incomingCallVoIPAcceptButton: S.current.answer,
        outgoingVideoCallPageMessage: S.current.onACall,
        outgoingVoiceCallPageMessage: S.current.onACall,
      ),
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          channelID: AppConfig.zegoCallResourceId,
          channelName: S.current.audioCallInvitationNotification,
          messageChannelID: AppConfig.zegoChatResourceId,
          messageChannelName: S.current.newMessageNotification,
        ),
      ),
      ringtoneConfig: ZegoCallRingtoneConfig(isVibrate: (data) {
        return SS.inAppMessage.vibrationReminderRx();
      }, isRing: (data) {
        return SS.inAppMessage.bellReminderRx();
      }),
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
          final isVideoCall = _isVideoCall;
          _clearCallState();
          _callId = callID;
          _isVideoCall = isVideoCall;
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
        ) async {
          _callId = callID;
          _isVideoCall = callType == ZegoCallInvitationType.videoCall;
          _callInvitee = ZegoUIKit().getLocalUser().id;
          _callInviter = caller.id;
          _isWaitCallEndDialog = true;
          print('onIncomingCallReceived');

          //申请权限
          await checkPermission(callType == ZegoCallInvitationType.videoCall);

          //自动接听
          if (CallCustomData.fromJsonString(customData)?.autoAccept == true) {
            acceptCall(customData: customData);
          }
        },
        onOutgoingCallRejectedCauseBusy: (
          String callID,
          ZegoCallUser callee,
          String customData,
        ) {
          Loading.showToast(S.current.thePartyEngagedCall);
        },
        onIncomingCallDeclineButtonPressed: () {
          _sendCallRejectMessage(_callInviter);
          _clearCallState();
        },
        onOutgoingCallCancelButtonPressed: () {
          _sendCallRejectMessage(_callInvitee);
          _clearCallState();
        },
        onOutgoingCallTimeout: (callId, callees, isVideoCall){
          _sendCallRejectMessage(callees.first.id);
          _clearCallState();
        }
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
      systemUiOverlayStyle: SystemUI.lightStyle,
      //邀请人
      inviter: ZegoCallInvitationInviterUIConfig(
        backgroundBuilder: backgroundBuilder,
      ),
      //被邀请人
      invitee: ZegoCallInvitationInviteeUIConfig(
        backgroundBuilder: backgroundBuilder,
        requirePopUp: (data) {
          final customData = CallCustomData.fromJsonString(data.customData);
          return ZegoCallInvitationNotifyPopUpUIConfig(
            //自动接听时，不显示顶部的呼入对话框
            visible: customData?.autoAccept != true,
          );
        },
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
      //不显示自己的头像
      if(user?.id == SS.login.userId?.toString()){
        return SizedBox.fromSize(size: size);
      }
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

    //发起方默认是否开启摄像头
    final customData = CallCustomData.fromJsonString(data.customData);
    if (customData?.enableCamera == false &&
        data.inviter?.id == SS.login.userId.toString()) {
      config.turnOnCameraWhenJoining = false;
    }

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
  Future<void> _callingPay(Duration duration) async {
    AppLogger.d(
        '_callingPay: _callId=$_callId, _callInviter=$_callInviter, _callPayTime=$_callPayTime, duration=$duration');

    //发起方扣费
    if (_callId.isEmpty || _callInviter != SS.login.userId.toString()) {
      return;
    }
    //每分钟调一次接口进行扣费
    final now = DateTime.now();
    if (_callPayTime != null &&
        now.difference(_callPayTime ?? now).inMinutes <= 0) {
      return;
    }
    _callPayTime = now;

    final orderId = int.tryParse(_callId);
    if (orderId == null) {
      hangUpCall();
      AppLogger.w('订单ID解析失败，无法扣费');
      return;
    }

    AppLogger.d('扣费前时间： ${DateTime.now()}');
    final response =
        await IMApi.chatOrderPay(orderId: orderId, uuid: _callPayUuid);
    if (response.isSuccess && response.data != null) {
      AppLogger.d('扣费成功: ${DateTime.now()}');
      final data = response.data!;
      _callPayUuid = data.uuid;
      //扣费提醒
      _showPayDialogIfNeed(data, duration);
    } else {
      hangUpCall();
      AppLogger.w('扣费失败，挂断通话');
    }
  }

  ///扣费提醒对话框
  void _showPayDialogIfNeed(ChatCallPayModel data, Duration duration) async {
    final userId = int.tryParse(_callInvitee);
    if (data.windows.isEmpty || !_callRechargeDialogAgain || userId == null) {
      return;
    }
    //可用分钟数
    final usableMinutes = (data.duration / 60).floor();
    if (data.windows.contains(usableMinutes)) {
      final result = await ChatCallRechargeDialog.show(
        isVideoCall: _isVideoCall,
        userId: userId,
      );
      if (result == true) {
        //TODO 弹出充值对话框
        Loading.showToast(S.current.theRechargeDialog);
        return;
      }
      if (result == false) {
        _callRechargeDialogAgain = false;
        return;
      }
    }
  }

  void _clearCallState() {
    _callId = '';
    _isVideoCall = false;
    _callInviter = '';
    _callInvitee = '';
    _callPayTime = null;
    _callPayUuid = null;
    _callRechargeDialogAgain = true;
  }

  ///发送拒绝接听自定义消息
  Future<void> _sendCallRejectMessage(String conversationId) async {
    if (conversationId.isNotEmpty) {
      ChatManager().sendCustomMessage(
        conversationId: conversationId,
        conversationType: ZIMConversationType.peer,
        customType: CustomMessageType.callReject.value,
        customMessage: MessageCallRejectContent(
          isVideoCall: _isVideoCall,
          message: S.current.canceled,
        ).toJsonString(),
      );
    }
  }

  Future<void> _uninitChatCall() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _clearCallState();
    _isWaitCallEndDialog = false;
  }
}

///音视频通话自定义数据
class CallCustomData {
  ///是否自动接听
  final bool autoAccept;

  ///接听时是否启用摄像头
  final bool enableCamera;

  CallCustomData(this.autoAccept, this.enableCamera);

  static CallCustomData? fromJsonString(String jsonStr) {
    try {
      if (jsonStr.isNotEmpty) {
        final json = jsonDecode(jsonStr);
        return CallCustomData(
          json['autoAccept'],
          json['enableCamera'],
        );
      }
    } catch (ex) {
      AppLogger.w(ex);
    }
    return null;
  }

  String toJsonString() {
    return jsonEncode({
      'autoAccept': autoAccept,
      'enableCamera': enableCamera,
    });
  }
}
