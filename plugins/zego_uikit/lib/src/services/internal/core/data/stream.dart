// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_express_engine/zego_express_engine.dart';

// Project imports:
import 'package:zego_uikit/src/services/internal/internal.dart';
import 'package:zego_uikit/src/services/services.dart';

mixin ZegoUIKitCoreDataStream {
  final Map<String, ZegoUIKitCoreMixerStream> mixerStreamDic =
      {}; // key:stream_id

  final Map<String, String> streamDic = {}; // stream_id:user_id

  ZegoAudioVideoResourceMode playResourceMode =
      ZegoAudioVideoResourceMode.defaultMode;

  bool isAllPlayStreamAudioVideoMuted = false;

  StreamController<List<ZegoUIKitCoreUser>>? audioVideoListStreamCtrl;
  StreamController<String>? turnOnYourCameraRequestStreamCtrl;
  StreamController<ZegoUIKitReceiveTurnOnLocalMicrophoneEvent>?
      turnOnYourMicrophoneRequestStreamCtrl;
  StreamController<ZegoUIKitReceiveSEIEvent>? receiveSEIStreamCtrl;

  ZegoUIKitVideoInternalConfig pushVideoConfig = ZegoUIKitVideoInternalConfig();

  void initStream() {
    ZegoLoggerService.logInfo(
      'init stream',
      tag: 'uikit-stream',
      subTag: 'init',
    );
    audioVideoListStreamCtrl ??=
        StreamController<List<ZegoUIKitCoreUser>>.broadcast();
    turnOnYourCameraRequestStreamCtrl ??= StreamController<String>.broadcast();
    turnOnYourMicrophoneRequestStreamCtrl ??= StreamController<
        ZegoUIKitReceiveTurnOnLocalMicrophoneEvent>.broadcast();
    receiveSEIStreamCtrl ??=
        StreamController<ZegoUIKitReceiveSEIEvent>.broadcast();
  }

  void uninitStream() {
    ZegoLoggerService.logInfo(
      'uninit stream',
      tag: 'uikit-stream',
      subTag: 'uninit',
    );

    audioVideoListStreamCtrl?.close();
    audioVideoListStreamCtrl = null;

    turnOnYourCameraRequestStreamCtrl?.close();
    turnOnYourCameraRequestStreamCtrl = null;

    turnOnYourMicrophoneRequestStreamCtrl?.close();
    turnOnYourMicrophoneRequestStreamCtrl = null;

    receiveSEIStreamCtrl?.close();
    receiveSEIStreamCtrl = null;
  }

  String getLocalStreamID(ZegoStreamType streamType) {
    return getLocalStreamChannel(streamType).streamID;
  }

  ZegoUIKitCoreStreamInfo getLocalStreamChannel(ZegoStreamType streamType) {
    return getUserStreamChannel(
      ZegoUIKitCore.shared.coreData.localUser,
      streamType,
    );
  }

  ZegoUIKitCoreStreamInfo getUserStreamChannel(
    ZegoUIKitCoreUser user,
    ZegoStreamType streamType,
  ) {
    switch (streamType) {
      case ZegoStreamType.main:
        return user.mainChannel;
      case ZegoStreamType.media:
      case ZegoStreamType.screenSharing:
      case ZegoStreamType.mix:
        return user.auxChannel;
      // return user.thirdChannel;
    }
  }

  ZegoStreamType getStreamTypeByID(String streamID) {
    if (streamID.endsWith(ZegoStreamType.main.text)) {
      return ZegoStreamType.main;
    } else if (streamID.endsWith(ZegoStreamType.media.text)) {
      return ZegoStreamType.media;
    } else if (streamID.endsWith(ZegoStreamType.screenSharing.text)) {
      return ZegoStreamType.screenSharing;
    } else if (streamID.endsWith(ZegoStreamType.mix.text)) {
      return ZegoStreamType.mix;
    }

    assert(false);
    return ZegoStreamType.main;
  }

  void clearStream() {
    ZegoLoggerService.logInfo(
      'clear stream',
      tag: 'uikit-stream',
      subTag: 'clearStream',
    );

    if (ZegoUIKitCore.shared.coreData.isScreenSharing.value) {
      ZegoUIKitCore.shared.coreData.stopSharingScreen();
    }

    for (final user in ZegoUIKitCore.shared.coreData.remoteUsersList) {
      if (user.mainChannel.streamID.isNotEmpty) {
        stopPlayingStream(user.mainChannel.streamID);
      }
      user.destroyTextureRenderer(streamType: ZegoStreamType.main);

      if (user.auxChannel.streamID.isNotEmpty) {
        stopPlayingStream(user.auxChannel.streamID);
      }
      user.destroyTextureRenderer(streamType: ZegoStreamType.screenSharing);
    }

    if (ZegoUIKitCore
        .shared.coreData.localUser.mainChannel.streamID.isNotEmpty) {
      stopPublishingStream(streamType: ZegoStreamType.main);
      ZegoUIKitCore.shared.coreData.localUser
          .destroyTextureRenderer(streamType: ZegoStreamType.main);
    }
    if (ZegoUIKitCore
        .shared.coreData.localUser.auxChannel.streamID.isNotEmpty) {
      stopPublishingStream(streamType: ZegoStreamType.screenSharing);
      ZegoUIKitCore.shared.coreData.localUser
          .destroyTextureRenderer(streamType: ZegoStreamType.screenSharing);
    }
  }

  Future<void> startPreview() async {
    ZegoLoggerService.logInfo(
      'start preview',
      tag: 'uikit-stream',
      subTag: 'start preview',
    );

    await createLocalUserVideoView(
      streamType: ZegoStreamType.main,
      onViewCreated: onViewCreatedByStartPreview,
    );
  }

  Future<void> onViewCreatedByStartPreview(ZegoStreamType streamType) async {
    ZegoLoggerService.logInfo(
      'start preview, on view created',
      tag: 'uikit-stream',
      subTag: 'onViewCreatedByStartPreview',
    );

    assert(ZegoUIKitCore.shared.coreData.localUser.mainChannel.viewID != -1);

    final previewCanvas = ZegoCanvas(
      ZegoUIKitCore.shared.coreData.localUser.mainChannel.viewID,
      viewMode: pushVideoConfig.useVideoViewAspectFill
          ? ZegoViewMode.AspectFill
          : ZegoViewMode.AspectFit,
    );

    ZegoExpressEngine.instance
      ..enableCamera(ZegoUIKitCore.shared.coreData.localUser.camera.value)
      ..startPreview(canvas: previewCanvas);
  }

  Future<void> stopPreview() async {
    ZegoLoggerService.logInfo(
      'stop preview',
      tag: 'uikit-stream',
      subTag: 'stop preview',
    );

    await ZegoUIKitCore.shared.coreData.localUser
        .destroyTextureRenderer(streamType: ZegoStreamType.main);

    await ZegoExpressEngine.instance.stopPreview();
  }

  Future<void> startPublishingStream({
    required ZegoStreamType streamType,
  }) async {
    final targetStreamID = getLocalStreamID(streamType);
    if (targetStreamID.isNotEmpty) {
      ZegoLoggerService.logWarn(
        'local user stream id($targetStreamID) of $streamType is not empty',
        tag: 'uikit-stream',
        subTag: 'start publish stream',
      );
      return;
    }

    getLocalStreamChannel(streamType)
      ..streamID = generateStreamID(
        ZegoUIKitCore.shared.coreData.localUser.id,
        ZegoUIKitCore.shared.coreData.room.id,
        streamType,
      )
      ..streamTimestamp =
          ZegoUIKitCore.shared.coreData.networkDateTime_.millisecondsSinceEpoch;
    streamDic[getLocalStreamChannel(streamType).streamID] =
        ZegoUIKitCore.shared.coreData.localUser.id;

    ZegoLoggerService.logInfo(
      'stream dict add $streamType ${getLocalStreamChannel(streamType).streamID} for ${ZegoUIKitCore.shared.coreData.localUser.id}, '
      'now stream dict:$streamDic',
      tag: 'uikit-stream',
      subTag: 'start publish stream',
    );

    ZegoLoggerService.logInfo(
      'start publish, '
      '${getLocalStreamChannel(streamType).streamID}',
      tag: 'uikit-stream',
      subTag: 'start publish stream',
    );

    await createLocalUserVideoView(
      streamType: streamType,
      onViewCreated: onViewCreatedByStartPublishingStream,
    );
  }

  Future<void> onViewCreatedByStartPublishingStream(
    ZegoStreamType streamType,
  ) async {
    /// advance config
    switch (streamType) {
      case ZegoStreamType.main:
        assert(getLocalStreamChannel(streamType).viewID != -1);
        final canvas = ZegoCanvas(
          getLocalStreamChannel(streamType).viewID,
          viewMode: pushVideoConfig.useVideoViewAspectFill
              ? ZegoViewMode.AspectFill
              : ZegoViewMode.AspectFit,
        );

        await ZegoExpressEngine.instance
            .enableCamera(ZegoUIKitCore.shared.coreData.localUser.camera.value);
        await ZegoExpressEngine.instance.muteMicrophone(
            !ZegoUIKitCore.shared.coreData.localUser.microphone.value);
        await ZegoExpressEngine.instance.startPreview(canvas: canvas);
        break;
      case ZegoStreamType.media:
        await ZegoExpressEngine.instance.setVideoSource(
          ZegoVideoSourceType.Player,
          instanceID:
              ZegoUIKitCore.shared.coreData.media.currentPlayer!.getIndex(),
          channel: streamType.channel,
        );
        await ZegoExpressEngine.instance.setAudioSource(
          ZegoAudioSourceType.MediaPlayer,
          channel: streamType.channel,
        );

        await ZegoExpressEngine.instance.setVideoConfig(
          ZegoUIKitCore.shared.coreData.media.getPreferVideoConfig(),
          channel: streamType.channel,
        );

        final canvas = ZegoCanvas(
          ZegoUIKitCore.shared.coreData
              .getLocalStreamChannel(streamType)
              .viewID,
          viewMode: ZegoViewMode.AspectFit,
        );
        ZegoUIKitCore.shared.coreData.media.currentPlayer!
            .setPlayerCanvas(canvas);
        break;
      case ZegoStreamType.screenSharing:
      case ZegoStreamType.mix:
        await ZegoExpressEngine.instance.setVideoConfig(
          ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset540P),
          channel: streamType.channel,
        );
        break;
    }

    await ZegoExpressEngine.instance.startPublishingStream(
      getLocalStreamID(streamType),
      channel: streamType.channel,
    );

    notifyStreamListControl(streamType);
  }

  Future<void> stopPublishingStream({
    required ZegoStreamType streamType,
  }) async {
    final targetStreamID = getLocalStreamID(streamType);
    ZegoLoggerService.logInfo(
      'stop $streamType $targetStreamID}',
      tag: 'uikit-stream',
      subTag: 'stop publish stream',
    );

    if (targetStreamID.isEmpty) {
      ZegoLoggerService.logInfo(
        'stream id is empty',
        tag: 'uikit-stream',
        subTag: 'stop publish stream',
      );

      return;
    }

    streamDic.remove(targetStreamID);
    ZegoLoggerService.logInfo(
      'stream dict remove $targetStreamID, now stream dict:$streamDic',
      tag: 'uikit-stream',
      subTag: 'stop publish stream',
    );

    getLocalStreamChannel(streamType)
      ..streamID = ''
      ..streamTimestamp = 0;

    ZegoUIKitCore.shared.coreData.localUser
        .destroyTextureRenderer(streamType: streamType);

    switch (streamType) {
      case ZegoStreamType.main:
        await ZegoExpressEngine.instance.stopPreview();
        break;
      case ZegoStreamType.media:
        await ZegoExpressEngine.instance.setVideoSource(
          ZegoVideoSourceType.None,
          channel: streamType.channel,
        );
        await ZegoExpressEngine.instance.setAudioSource(
          ZegoAudioSourceType.Default,
          channel: streamType.channel,
        );
        break;
      case ZegoStreamType.screenSharing:
        await ZegoExpressEngine.instance.setVideoSource(
          ZegoVideoSourceType.None,
          channel: streamType.channel,
        );
        break;
      default:
        break;
    }

    await ZegoExpressEngine.instance
        .stopPublishingStream(channel: streamType.channel)
        .then((value) {
      audioVideoListStreamCtrl?.add(getAudioVideoList());
      ZegoUIKitCore.shared.coreData.screenSharingListStreamCtrl
          ?.add(getAudioVideoList(streamType: ZegoStreamType.screenSharing));
      ZegoUIKitCore.shared.coreData.media.mediaListStreamCtrl
          ?.add(getAudioVideoList(streamType: ZegoStreamType.media));
    });
  }

  Future<void> startPublishOrNot() async {
    if (ZegoUIKitCore.shared.coreData.room.id.isEmpty) {
      ZegoLoggerService.logError(
        'room id is empty',
        tag: 'uikit-stream',
        subTag: 'publish stream',
      );
      return;
    }

    if (ZegoUIKitCore.shared.coreData.localUser.camera.value ||
        ZegoUIKitCore.shared.coreData.localUser.cameraMuteMode.value ||
        ZegoUIKitCore.shared.coreData.localUser.microphone.value ||
        ZegoUIKitCore.shared.coreData.localUser.microphoneMuteMode.value) {
      startPublishingStream(
        streamType: ZegoStreamType.main,
      );
    } else {
      if (ZegoUIKitCore
          .shared.coreData.localUser.mainChannel.streamID.isNotEmpty) {
        stopPublishingStream(
          streamType: ZegoStreamType.main,
        );
      }
    }
  }

  Future<void> createLocalUserVideoView({
    required ZegoStreamType streamType,
    required void Function(ZegoStreamType) onViewCreated,
  }) async {
    final localStreamChannel = getLocalStreamChannel(streamType);
    if (-1 == localStreamChannel.viewID) {
      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        ZegoLoggerService.logInfo(
          'onViewCreated done, viewID:$viewID',
          tag: 'uikit-stream',
          subTag: 'create local user video view',
        );

        localStreamChannel.viewID = viewID;

        onViewCreated(streamType);
      }).then((widget) {
        localStreamChannel.view.value = widget;
        ZegoLoggerService.logInfo(
          'createCanvasView done, widget:$widget',
          tag: 'uikit-stream',
          subTag: 'create local user video view',
        );

        notifyStreamListControl(streamType);
      });
    } else {
      //  user view had created
      onViewCreated(streamType);
    }
  }

  Future<bool> mutePlayStreamAudioVideo(
    String userID,
    bool mute, {
    bool forAudio = true,
    bool forVideo = true,
  }) async {
    ZegoLoggerService.logInfo(
      'userID: $userID, mute: $mute, '
      'for audio:$forAudio, for video:$forVideo',
      tag: 'uikit-stream',
      subTag: 'mute play stream audio video',
    );

    final targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => userID == user.id);
    if (-1 == targetUserIndex) {
      ZegoLoggerService.logError(
        "can't find $userID",
        tag: 'uikit-stream',
        subTag: 'mute play stream audio video',
      );
      return false;
    }

    final targetUser =
        ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex];
    if (targetUser.mainChannel.streamID.isEmpty) {
      ZegoLoggerService.logError(
        "can't find $userID's stream",
        tag: 'uikit-stream',
        subTag: 'mute play stream audio video',
      );
      return false;
    }

    if (forAudio) {
      targetUser.microphoneMuteMode.value = mute;
      await ZegoExpressEngine.instance
          .mutePlayStreamAudio(targetUser.mainChannel.streamID, mute);
    }

    if (forVideo) {
      targetUser.cameraMuteMode.value = mute;
      await ZegoExpressEngine.instance
          .mutePlayStreamVideo(targetUser.mainChannel.streamID, mute);
    }

    return true;
  }

  Future<void> muteAllPlayStreamAudioVideo(bool isMuted) async {
    ZegoLoggerService.logInfo(
      'muted: $isMuted',
      tag: 'uikit-stream',
      subTag: 'mute all play stream audio video',
    );

    isAllPlayStreamAudioVideoMuted = isMuted;

    await ZegoExpressEngine.instance
        .muteAllPlayStreamVideo(isAllPlayStreamAudioVideoMuted);
    await ZegoExpressEngine.instance
        .muteAllPlayStreamAudio(isAllPlayStreamAudioVideoMuted);

    streamDic.forEach((streamID, userID) async {
      if (isMuted) {
        // stop playing stream
        await ZegoExpressEngine.instance.stopPlayingStream(streamID);
      } else {
        if (ZegoUIKitCore.shared.coreData.localUser.id != userID) {
          await startPlayingStream(streamID, userID);
        }
      }
    });
  }

  /// will change data variables
  Future<void> startPlayingStream(String streamID, String streamUserID) async {
    ZegoLoggerService.logInfo(
      'stream id: $streamID, user id:$streamUserID',
      tag: 'uikit-stream',
      subTag: 'start play stream',
    );

    final targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => streamUserID == user.id);
    assert(-1 != targetUserIndex);
    final targetUser =
        ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex];
    final streamType = getStreamTypeByID(streamID);

    getUserStreamChannel(targetUser, streamType)
      ..streamID = streamID
      ..streamTimestamp =
          ZegoUIKitCore.shared.coreData.networkDateTime_.millisecondsSinceEpoch;

    if (getUserStreamChannel(targetUser, streamType).viewID != -1 &&
        getUserStreamChannel(targetUser, streamType).view.value != null) {
      final viewID = getUserStreamChannel(targetUser, streamType).viewID;
      ZegoLoggerService.logInfo(
        'canvas view had created before, '
        'viewID:$viewID, '
        'user id:$streamUserID, '
        'stream id:$streamID, ',
        tag: 'uikit-stream',
        subTag: 'start play stream',
      );

      playStreamOnViewCreated(
        streamID: streamID,
        streamUserID: streamUserID,
        viewID: viewID,
        streamType: streamType,
      );
    } else {
      await ZegoExpressEngine.instance.createCanvasView((viewID) async {
        ZegoLoggerService.logInfo(
          'createCanvasView, onViewCreated done, '
          'viewID:$viewID, '
          'user id:$streamUserID, '
          'stream id:$streamID, ',
          tag: 'uikit-stream',
          subTag: 'start play stream',
        );

        getUserStreamChannel(targetUser, streamType).viewID = viewID;

        playStreamOnViewCreated(
          streamID: streamID,
          streamUserID: streamUserID,
          viewID: viewID,
          streamType: streamType,
        );
      }).then((widget) {
        ZegoLoggerService.logInfo(
          'createCanvasView done, '
          'widget:$widget'
          'user id:$streamUserID, '
          'stream id:$streamID, ',
          tag: 'uikit-stream',
          subTag: 'start play stream',
        );

        getUserStreamChannel(targetUser, streamType).view.value = widget;

        notifyStreamListControl(streamType);
      });
    }
  }

  void playStreamOnViewCreated({
    required String streamID,
    required String streamUserID,
    required int viewID,
    required ZegoStreamType streamType,
  }) async {
    final canvas = ZegoCanvas(
      viewID,
      viewMode: ZegoStreamType.main == streamType
          ? (pushVideoConfig.useVideoViewAspectFill
              ? ZegoViewMode.AspectFill
              : ZegoViewMode.AspectFit)

          /// screen share/media default AspectFit
          : ZegoViewMode.AspectFit,
    );
    final playConfig = ZegoPlayerConfig(
      ZegoUIKitCore.shared.coreData.playResourceMode.toSdkValue,
    );

    ZegoLoggerService.logInfo(
      'ready start, stream id: $streamID, user id:$streamUserID',
      tag: 'uikit-stream',
      subTag: 'start play stream',
    );
    await ZegoExpressEngine.instance
        .startPlayingStream(
      streamID,
      canvas: canvas,
      config: playConfig,
    )
        .then((value) {
      ZegoLoggerService.logInfo(
        'finish play stream id: $streamID, user id:$streamUserID',
        tag: 'uikit-stream',
        subTag: 'start play stream',
      );
    });
  }

  void notifyStreamListControl(ZegoStreamType streamType) {
    switch (streamType) {
      case ZegoStreamType.main:
        audioVideoListStreamCtrl?.add(getAudioVideoList());
        break;
      case ZegoStreamType.media:
        ZegoUIKitCore.shared.coreData.media.mediaListStreamCtrl
            ?.add(getAudioVideoList(streamType: streamType));
        break;
      case ZegoStreamType.screenSharing:
        ZegoUIKitCore.shared.coreData.screenSharingListStreamCtrl
            ?.add(getAudioVideoList(streamType: streamType));
        break;
      case ZegoStreamType.mix:
        break;
    }
  }

  /// will change data variables
  void stopPlayingStream(String streamID) {
    ZegoLoggerService.logInfo(
      'ready stop stream id: $streamID',
      tag: 'uikit-stream',
      subTag: 'stop play stream',
    );
    assert(streamID.isNotEmpty);

    // stop playing stream
    ZegoExpressEngine.instance.stopPlayingStream(streamID);

    final targetUserID =
        streamDic.containsKey(streamID) ? streamDic[streamID] : '';
    ZegoLoggerService.logInfo(
      'stopped, stream id $streamID, user id  is: $targetUserID',
      tag: 'uikit-stream',
      subTag: 'stop play stream',
    );
    final targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => targetUserID == user.id);
    if (-1 != targetUserIndex) {
      final targetUser =
          ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex];

      final streamType = getStreamTypeByID(streamID);
      getUserStreamChannel(targetUser, streamType)
        ..streamID = ''
        ..streamTimestamp = 0;
      targetUser.destroyTextureRenderer(streamType: streamType);
      if (streamType == ZegoStreamType.main) {
        targetUser
          ..camera.value = false
          ..cameraMuteMode.value = false
          ..microphone.value = false
          ..microphoneMuteMode.value = false;
      }
    }

    // clear streamID
    streamDic.remove(streamID);
    ZegoLoggerService.logInfo(
      'stream dict remove $streamID, $streamDic',
      tag: 'uikit-stream',
      subTag: 'stop play stream',
    );
  }

  List<ZegoUIKitCoreUser> getAudioVideoList({
    ZegoStreamType streamType = ZegoStreamType.main,
  }) {
    return ZegoUIKitCore.shared.coreData.streamDic.entries
        .where((value) => value.key.endsWith(streamType.text))
        .map((entry) {
      final targetUserID = entry.value;
      if (targetUserID == ZegoUIKitCore.shared.coreData.localUser.id) {
        return ZegoUIKitCore.shared.coreData.localUser;
      }
      return ZegoUIKitCore.shared.coreData.remoteUsersList.firstWhere(
          (user) => targetUserID == user.id,
          orElse: ZegoUIKitCoreUser.empty);
    }).where((user) {
      if (user.id.isEmpty) {
        return false;
      }

      if (streamType == ZegoStreamType.main) {
        /// if camera is in mute mode, same as open state
        final isCameraOpen = user.camera.value || user.cameraMuteMode.value;

        /// if microphone is in mute mode, same as open state
        final isMicrophoneOpen =
            user.microphone.value || user.microphoneMuteMode.value;

        /// only open camera or microphone
        return isCameraOpen || isMicrophoneOpen;
      }

      return true;
    }).toList();
  }

  Future<void> startPlayAnotherRoomAudioVideo(
    String roomID,
    String userID,
    String userName,
  ) async {
    var targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => userID == user.id);
    final isUserExist = -1 != targetUserIndex;
    if (!isUserExist) {
      ZegoUIKitCore.shared.coreData.remoteUsersList
          .add(ZegoUIKitCoreUser(userID, userName)..isAnotherRoomUser = true);

      ZegoLoggerService.logInfo(
        'add $userID, now remote list:${ZegoUIKitCore.shared.coreData.remoteUsersList}',
        tag: 'uikit-stream',
        subTag: 'start play another room stream',
      );
    }
    targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => userID == user.id);

    final streamID = generateStreamID(userID, roomID, ZegoStreamType.main);
    streamDic[streamID] = userID;
    ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex]
      ..mainChannel.streamID = streamID
      ..mainChannel.streamTimestamp =
          ZegoUIKitCore.shared.coreData.networkDateTime_.millisecondsSinceEpoch;

    ZegoLoggerService.logInfo(
      'roomID:$roomID, '
      'userID:$userID, userName:$userName, '
      'streamID:$streamID, '
      'targetUserIndex:$targetUserIndex, ',
      tag: 'uikit-stream',
      subTag: 'start play another room stream',
    );

    await ZegoExpressEngine.instance.createCanvasView((viewID) async {
      ZegoLoggerService.logInfo(
        'createCanvasView onViewCreated, '
        'viewID:$viewID, '
        'remote user list:${ZegoUIKitCore.shared.coreData.remoteUsersList}, '
        'targetUserIndex:$targetUserIndex, ',
        tag: 'uikit-stream',
        subTag: 'start play another room stream',
      );
      ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex].mainChannel
          .viewID = viewID;
      final canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      await ZegoExpressEngine.instance
          .startPlayingStream(streamID, canvas: canvas);
    }).then((widget) {
      ZegoLoggerService.logInfo(
        'createCanvasView done, '
        'widget:$widget, '
        'roomID:$roomID, '
        'userID:$userID, userName:$userName, '
        'streamID:$streamID, ',
        tag: 'uikit-stream',
        subTag: 'start play another room stream',
      );

      assert(widget != null);
      ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex].mainChannel
          .view.value = widget;

      notifyStreamListControl(ZegoStreamType.main);
      if (!isUserExist) {
        ZegoUIKitCore.shared.coreData.notifyUserListStreamControl();
      }
    });
  }

  Future<void> stopPlayAnotherRoomAudioVideo(String userID) async {
    ZegoLoggerService.logInfo(
      'userID:$userID',
      tag: 'uikit-stream',
      subTag: 'stop play another room stream',
    );

    final targetUserIndex = ZegoUIKitCore.shared.coreData.remoteUsersList
        .indexWhere((user) => userID == user.id);
    if (-1 != targetUserIndex) {
      final targetUser =
          ZegoUIKitCore.shared.coreData.remoteUsersList[targetUserIndex];

      final streamID = ZegoUIKitCore.shared.coreData
          .remoteUsersList[targetUserIndex].mainChannel.streamID;
      await ZegoExpressEngine.instance.stopPlayingStream(streamID);

      targetUser
        ..mainChannel.streamID = ''
        ..mainChannel.streamTimestamp = 0
        ..destroyTextureRenderer(streamType: ZegoStreamType.main)
        ..camera.value = false
        ..cameraMuteMode.value = false
        ..microphone.value = false
        ..microphoneMuteMode.value = false
        ..mainChannel.soundLevel?.add(0);

      streamDic.remove(streamID);
      ZegoUIKitCore.shared.coreData.remoteUsersList
          .removeWhere((user) => userID == user.id);
      ZegoLoggerService.logInfo(
        'stopped, userID:$userID, streamID:$streamID',
        tag: 'uikit-stream',
        subTag: 'start play another room stream',
      );

      notifyStreamListControl(ZegoStreamType.main);
      ZegoUIKitCore.shared.coreData.notifyUserListStreamControl();
    } else {
      ZegoLoggerService.logWarn(
        "can't find this user, userID:$userID",
        tag: 'uikit-stream',
        subTag: 'stop play another room stream',
      );
    }
  }

  Future<void> startPlayMixAudioVideo(
    String mixerID,
    List<ZegoUIKitCoreUser> users,
    Map<String, int> userSoundIDs,
  ) async {
    ZegoLoggerService.logWarn(
      'mixerID:$mixerID, users:$users, userSoundIDs:$userSoundIDs',
      tag: 'uikit-mixstream',
      subTag: 'start play mix audio video',
    );

    if (mixerStreamDic.containsKey(mixerID)) {
      for (var user in users) {
        if (-1 ==
            mixerStreamDic[mixerID]!
                .usersNotifier
                .value
                .indexWhere((e) => e.id == user.id)) {
          mixerStreamDic[mixerID]!.addUser(user);
        }
      }
      mixerStreamDic[mixerID]!.userSoundIDs.addAll(userSoundIDs);
    } else {
      mixerStreamDic[mixerID] = ZegoUIKitCoreMixerStream(
        mixerID,
        userSoundIDs,
        users,
      );

      ZegoExpressEngine.instance.createCanvasView((viewID) {
        mixerStreamDic[mixerID]!.viewID = viewID;
        final canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
        ZegoExpressEngine.instance.startPlayingStream(mixerID, canvas: canvas);

        Future.delayed(const Duration(seconds: 3), () {
          mixerStreamDic[mixerID]?.loaded.value = true;
        });
      }).then((widget) {
        assert(widget != null);
        mixerStreamDic[mixerID]!.view.value = widget;

        notifyStreamListControl(ZegoStreamType.main);
      });
    }
  }

  Future<void> stopPlayMixAudioVideo(String mixerID) async {
    ZegoLoggerService.logInfo(
      'mixerID:$mixerID',
      tag: 'uikit-mixstream',
      subTag: 'stop play mix audio video',
    );

    ZegoExpressEngine.instance.stopPlayingStream(mixerID);

    mixerStreamDic[mixerID]?.destroyTextureRenderer();
    mixerStreamDic.remove(mixerID);
  }
}
