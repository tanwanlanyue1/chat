import 'package:flutter/material.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///红包状态变更
class ChatRedPacketBuilder extends StatefulWidget {
  final ZIMKitMessage message;
  final WidgetBuilder builder;

  const ChatRedPacketBuilder({
    super.key,
    required this.message,
    required this.builder,
  });

  @override
  State<ChatRedPacketBuilder> createState() => _ChatRedPacketBuilderState();
}

class _ChatRedPacketBuilderState extends State<ChatRedPacketBuilder>
    with AutoDisposeMixin {

  ZIMKitMessage get message => widget.message;

  @override
  void initState() {
    super.initState();
    autoDisposeWorker(EventBus().listen(kEventRedPacketUpdate, (data) {
      refresh();
    }));
    refresh();
  }

  void refresh(){
    final content = SS.inAppMessage.removeRedPacketUpdateContent(message.zim.messageID);
    if(content != null){
      final receiveTime = content.receiveTime?.let(DateTime.fromMillisecondsSinceEpoch);
      message.setRedPacketLocal(
        MessageRedPacketLocal(
          status: content.status,
          receiveTime: receiveTime,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.message.localExtendedData,
        builder: (_, value, child) {
          return widget.builder.call(context);
        });
  }
}
