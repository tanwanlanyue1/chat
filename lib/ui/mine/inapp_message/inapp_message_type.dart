import 'package:guanjia/common/extension/list_extension.dart';

///应用内消息类型
enum InAppMessageType{

  ///语音视频速配 1，接收方收到
  callMatch,

  ///速配成功 2，发起方收到
  callMatchSuccess,

  ///订单状态变更 3，用户，佳丽，经纪人都收到
  orderUpdate,

}

extension InAppMessageTypeX on InAppMessageType{

  int get value => index + 1;

  static InAppMessageType? valueOf(int value){
    return InAppMessageType.values.safeElementAt(value - 1);
  }

}