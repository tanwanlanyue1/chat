

///自定义消息类型
enum CustomMessageType{

  ///系统通知 0
  sysNotice,

  ///红包 1
  redPacket,

  ///通话结束 2
  callEnd,

}

extension CustomMessageTypeX on CustomMessageType{

  int get value => index;

  static CustomMessageType? valueOf(int value){
    return CustomMessageType.values.elementAtOrNull(value);
  }

}