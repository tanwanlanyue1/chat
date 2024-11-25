///发送消息参数
class SendMessageParams {
  ///接收方
  final int toUid;

  ///消息类型 1文字 2图片 3视频 4定位
  final int type;

  ///消息内容
  String? msg;

  ///	图片/视频数据大小，单位为字节。
  int? fileSize;

  ///文件名称，格式建议为 “xxx.文件扩展名”
  String? fileName;

  ///	图片宽度，单位为像素（px）
  int? imgWidth;

  ///	图片高度，单位为像素（px）
  int? imgHeight;

  /// 图片的 URL 地址
  String? imgUrl;

  /// 视频时长，单位为秒。
  int? videoDuration;

  /// 视频的 URL 地址
  String? videoUrl;

  SendMessageParams({
    required this.toUid,
    required this.type,
    this.msg,
    this.fileSize,
    this.fileName,
    this.imgWidth,
    this.imgHeight,
    this.imgUrl,
    this.videoDuration,
    this.videoUrl,
  });

  Map<String, dynamic> toJson(){
    return {
      'toUid': toUid,
      'type': type,
      if(msg != null) 'msg': msg,
      if(fileSize != null) 'fileSize': fileSize,
      if(fileName != null) 'fileName': fileName,
      if(imgWidth != null) 'imgWidth': imgWidth,
      if(imgHeight != null) 'imgHeight': imgHeight,
      if(imgUrl != null) 'imgUrl': imgUrl,
      if(videoDuration != null) 'videoDuration': videoDuration,
      if(videoUrl != null) 'videoUrl': videoUrl,
    };
  }
}