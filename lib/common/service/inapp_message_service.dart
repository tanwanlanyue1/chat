import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/chat_event_notifier.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///应用消息服务
class InAppMessageService extends GetxService {

  final _streamController = StreamController<InAppMessage>.broadcast();

  @override
  void onInit() {
    super.onInit();

    //监听信令消息
    ChatEventNotifier().onReceiveCommandMessage.listen((event) {
      for (var message in event.messageList) {
        if (message is ZIMCommandMessage) {
          _onReceiveCommandMessage(message);
        }
      }
    });
  }

  void _onReceiveCommandMessage(ZIMCommandMessage message) {
    final content = utf8.decode(message.message);
    print('onReceiveCommandMessage====${content}');
    if (content.isEmpty) {
      return;
    }
    try {
      final json = jsonDecode(content);
      if(json == null){
        AppLogger.w('_onReceiveCommandMessage: json is null');
        return;
      }
      final message = InAppMessage.fromJson(json);
      message?.let(_streamController.add);
    } catch (ex) {
      AppLogger.w('_onReceiveCommandMessage: $ex');
    }
  }

  ///监听应用内消息
  StreamSubscription<InAppMessage> listen(void Function(InAppMessage message)? onData){
    return _streamController.stream.listen(onData);
  }

}
