

///自定义消息类型
enum CustomMessageType{

  ///系统通知 0
  sysNotice,

  ///红包 1
  redPacket,

}

extension CustomMessageTypeX on CustomMessageType{

  int get value => index;

  static CustomMessageType? valueOf(int value){
    return CustomMessageType.values.elementAtOrNull(value);
  }

}