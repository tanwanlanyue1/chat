import 'package:guanjia/common/extension/list_extension.dart';

///应用内消息类型
enum InAppMessageType{

  ///语音视频速配 1
  callMatch,

  ///速配成功 2
  callMatchSuccess,

}

extension InAppMessageTypeX on InAppMessageType{

  int get value => index + 1;

  static InAppMessageType? valueOf(int value){
    return InAppMessageType.values.safeElementAt(value - 1);
  }

}