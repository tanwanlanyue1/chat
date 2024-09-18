part of 'chat_manager.dart';

mixin _ChatSenderMixin {
  ///发送文本消息
  Future<bool> sendTextMessage({
    required String text,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    if (await _checkMessage(type: 1, msg: {'message': text})) {
      await ZIMKit().sendTextMessage(
        conversationId,
        conversationType,
        text,
      );
      return true;
    }
    return false;
  }

  ///发送图片消息
  Future<bool> sendImageMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    String? localExtendedData;
    try {
      final input = AsyncImageInput.input(FileInput(File(filePath)));
      final size = await ImageSizeGetter.getSizeAsync(input);
      if (size.width > 0 && size.height > 0) {
        localExtendedData = jsonEncode({
          'width': size.needRotate ? size.height : size.width,
          'height': size.needRotate ? size.width : size.height,
        });
      }
    } catch (ex) {
      AppLogger.w('获取图片尺寸信息失败，$ex');
    }

    if (await _checkMessage(type: 2)) {
      await ZIMKitCore.instance.sendMediaMessageExt(
        conversationId,
        conversationType,
        filePath,
        ZIMMessageType.image,
        localExtendedData: localExtendedData,
      );
      return true;
    }
    return false;
  }

  ///发送视频消息
  Future<bool> sendVideoMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    String? extendedData;
    try {
      final videoInfo = await FlutterVideoInfo().getVideoInfo(filePath);
      final durationMs = videoInfo?.duration ?? 0;
      if (videoInfo != null && durationMs > 0) {
        final needRotate = [90, 270].contains(videoInfo.orientation);
        final width = videoInfo.width ?? 0;
        final height = videoInfo.height ?? 0;

        extendedData = jsonEncode({
          'duration': (durationMs / 1000).ceil(), //毫秒转成秒
          'width': needRotate ? height : width,
          'height': needRotate ? width : height,
        });
      }
    } catch (ex) {
      AppLogger.w('获取视频信息失败，$ex');
    }

    if (await _checkMessage(type: 3)) {
      await ZIMKitCore.instance.sendMediaMessageExt(
        conversationId,
        conversationType,
        filePath,
        ZIMMessageType.video,
        extendedData: extendedData,
      );
      return true;
    }
    return false;
  }

  ///发送自定义消息
  Future<bool> sendCustomMessage({
    required int customType,
    required String customMessage,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    if (await _checkMessage(
        type: 5,
        msg: {'customType': customType, 'customMessage': customMessage})) {
      await ZIMKitCore.instance.sendCustomMessage(
        conversationId,
        conversationType,
        customType: customType,
        customMessage: customMessage,
      );
      return true;
    }
    return false;
  }

  ///发送本地消息
  Future<bool> sendLocalMessage({
    required ZIMMessage message,
    required String conversationId,
    required ZIMConversationType conversationType,
    required String senderUserId,
}) async{
    final result = await ZIM.getInstance()?.insertMessageToLocalDB(
      message,
      conversationId,
      conversationType,
      senderUserId,
    );
    return result != null;
  }

  ///检查消息是否可发送
  ///- type 消息类型 1文字 2图片 3视频 4定位 5自定义消息
  ///- msg 消息内容
  Future<bool> _checkMessage({
    required int type,
    Map<String, dynamic> msg = const {},
  }) async {
    final response = await IMApi.sendMessage(type: type, msg: msg);
    final ret = response.isSuccess;
    if (!ret) {
      response.showErrorMessage();
    }
    return ret;
  }
}
