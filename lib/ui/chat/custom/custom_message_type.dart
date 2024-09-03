

///自定义消息类型
enum CustomMessageType{

  ///系统通知 0
  sysNotice,

  ///红包 1
  redPacket,

  ///音视频通话结束 2
  callEnd,

  ///转账 3
  transfer,

  ///订单消息（创建，状态变更） 4
  order,

  ///速配 5
  callMatch,

  /// 音视频通话发起 6
  @Deprecated('产品说不需要了')
  callInvite,

  ///被邀请人拒绝接听 7
  callReject,

}

extension CustomMessageTypeX on CustomMessageType{

  int get value => index;

  static CustomMessageType? valueOf(int value){
    return CustomMessageType.values.elementAtOrNull(value);
  }

}