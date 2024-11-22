part of 'chat_manager.dart';

mixin _ChatSenderMixin {
  ///发送文本消息
  Future<bool> sendTextMessage({
    required String text,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    return _sendMessage(
      toUid: int.parse(conversationId),
      type: 1,
      message: text
    );
  }

  ///发送图片消息
  Future<bool> sendImageMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    return _sendMessage(
        toUid: int.parse(conversationId),
        type: 2,
        file: File(filePath)
    );
  }

  ///发送视频消息
  Future<bool> sendVideoMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    return _sendMessage(
        toUid: int.parse(conversationId),
        type: 3,
        file: File(filePath)
    );

    // String? extendedData;
    // try {
    //   final videoInfo = await FlutterVideoInfo().getVideoInfo(filePath);
    //   final durationMs = videoInfo?.duration ?? 0;
    //   if (videoInfo != null && durationMs > 0) {
    //     final needRotate = [90, 270].contains(videoInfo.orientation);
    //     final width = videoInfo.width ?? 0;
    //     final height = videoInfo.height ?? 0;
    //
    //     extendedData = jsonEncode({
    //       'duration': (durationMs / 1000).ceil(), //毫秒转成秒
    //       'width': needRotate ? height : width,
    //       'height': needRotate ? width : height,
    //     });
    //   }
    // } catch (ex) {
    //   AppLogger.w('获取视频信息失败，$ex');
    // }
    //
    // if (await _checkMessage(type: 3)) {
    //   await ZIMKitCore.instance.sendMediaMessageExt(
    //     conversationId,
    //     conversationType,
    //     filePath,
    //     ZIMMessageType.video,
    //     extendedData: extendedData,
    //   );
    //   return true;
    // }
    // return false;
  }

  ///发送位置消息
  Future<bool> sendLocationMessage({
    required MessageLocationContent content,
    required String conversationId,
  }) async {
    return _sendMessage(
        toUid: int.parse(conversationId),
        type: 4,
        message: jsonEncode(content.toJson()),
    );
  }

  ///发送自定义消息
  Future<bool> sendCustomMessage({
    required int customType,
    required String customMessage,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
      await ZIMKitCore.instance.sendCustomMessage(
        conversationId,
        conversationType,
        customType: customType,
        customMessage: customMessage,
      );
      return true;
  }

  ///发送本地消息
  Future<bool> sendLocalMessage({
    required ZIMMessage message,
    required String conversationId,
    required ZIMConversationType conversationType,
    required String senderUserId,
  }) async {
    final result = await ZIM.getInstance()?.insertMessageToLocalDB(
          message,
          conversationId,
          conversationType,
          senderUserId,
        );
    return result != null;
  }

  /// 发送消息
  ///- toUid 接收方
  ///- type 消息类型 1文字 2图片 3视频 4定位
  ///- message 消息内容
  ///- file 图片或者视频文件
  Future<bool> _sendMessage({
    required int toUid,
    required int type,
    String? message,
    File? file,
  }) async {
    final response = await IMApi.sendMessage(
      toUid: toUid,
      type: type,
      message: message,
      file: file,
    );
    final ret = response.isSuccess;
    if (!ret) {
      response.showErrorMessage();
    }
    return ret;
  }
}
