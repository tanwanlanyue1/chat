part of 'chat_manager.dart';

mixin _ChatSenderMixin {
  ///发送文本消息
  Future<bool> sendTextMessage({
    required String text,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    return _sendMessage(SendMessageParams(
      toUid: int.parse(conversationId),
      type: 1,
      msg: text,
    ));
  }

  ///发送图片消息
  Future<bool> sendImageMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {

    try {

      //上传图片
      final fileName = basename(filePath);
      final response =
      await UserApi.upload(filePath: filePath, fileName: fileName);
      final imgUrl = response.data;
      if (!response.isSuccess || imgUrl?.isNotEmpty != true) {
        Loading.showToast(S.current.sendFail);
        return false;
      }

      //获取图片信息
      final file = File(filePath);
      final fileInfo = await file.stat();
      final input = AsyncImageInput.input(FileInput(file));
      final size = await ImageSizeGetter.getSizeAsync(input);

      return _sendMessage(SendMessageParams(
        toUid: int.parse(conversationId),
        type: 2,
        imgWidth: size.width,
        imgHeight: size.height,
        imgUrl: imgUrl,
        fileSize: fileInfo.size,
        fileName: basename(fileName),
      ));
    } catch (ex) {
      Loading.showToast(S.current.sendFail);
      AppLogger.w(ex);
      return false;
    }
  }

  ///发送视频消息
  Future<bool> sendVideoMessage({
    required String filePath,
    required ZIMConversationType conversationType,
    required String conversationId,
  }) async {
    try {

      //获取视频信息
      final videoInfo = await VideoCompress.getMediaInfo(filePath);

      //获取视频首帧图片缩略图
      final thumb = await VideoCompress.getFileThumbnail(filePath);
      final input = AsyncImageInput.input(FileInput(thumb));
      final thumbSize = await ImageSizeGetter.getSizeAsync(input);

      //上传视频和缩略图
      final fileName = basename(filePath);
      final responses = await Future.wait([
        UserApi.upload(filePath: filePath, fileName: fileName),
        UserApi.upload(filePath: thumb.path),
      ]);
      if(!responses.first.isSuccess || !responses.last.isSuccess){
        AppLogger.w('上传视频或者缩率图失败');
        Loading.showToast(S.current.sendFail);
        return false;
      }
      final videoUrl = responses.first.data;
      final thumbUrl = responses.last.data;

      //发送消息
      return _sendMessage(SendMessageParams(
        toUid: int.parse(conversationId),
        type: 3,
        imgWidth: thumbSize.width,
        imgHeight: thumbSize.height,
        imgUrl: thumbUrl,
        videoDuration: ((videoInfo.duration ?? 0) / 1000).ceil(),
        videoUrl: videoUrl,
        fileName: fileName,
        fileSize: videoInfo.filesize,
      ));
    } catch (ex) {
      Loading.showToast(S.current.sendFail);
      AppLogger.w(ex);
      return false;
    }

  }

  ///发送位置消息
  Future<bool> sendLocationMessage({
    required MessageLocationContent content,
    required String conversationId,
  }) async {
    return _sendMessage(SendMessageParams(
      toUid: int.parse(conversationId),
      type: 4,
      msg: jsonEncode(content.toJson()),
    ));
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
  Future<bool> _sendMessage(SendMessageParams params) async {
    final response = await IMApi.sendMessage(params);
    final ret = response.isSuccess;
    if (!ret) {
      response.showErrorMessage();
    }
    return ret;
  }
}
