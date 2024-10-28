import 'package:get/get.dart';

///自定义消息类型
enum CustomMessageType {

  ///红包 1
  redPacket(1),

  ///音视频通话结束 2
  callEnd(2),

  ///转账 3
  transfer(3),

  ///订单消息（创建，状态变更） 4
  order(4),

  ///速配 5
  callMatch(5),

  /// 音视频通话发起 6
  @Deprecated('产品说不需要了')
  callInvite(6),

  ///被邀请人拒绝接听 7
  callReject(7),

  ///位置消息 8
  location(8),

  ///征友约会 9
  dating(9);

  final int value;

  const CustomMessageType(this.value);

  static CustomMessageType? valueOf(int value) {
    return CustomMessageType.values
        .firstWhereOrNull((element) => element.value == value);
  }
}
