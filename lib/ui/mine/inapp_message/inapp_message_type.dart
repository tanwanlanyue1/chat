import 'package:guanjia/common/extension/list_extension.dart';

///应用内消息类型
enum InAppMessageType{

  ///视频速配 1
  videoMatch,

  ///语音速配 2
  voiceMatch,

}

extension InAppMessageTypeX on InAppMessageType{

  int get value => index + 1;

  static InAppMessageType? valueOf(int value){
    return InAppMessageType.values.safeElementAt(value - 1);
  }

}