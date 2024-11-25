import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/auto_dispose_mixin.dart';
import 'event_bus.dart';

///事件总线监听
class EventBusListener extends StatefulWidget {
  final String eventName;
  final void Function(BuildContext context, dynamic data) onEvent;
  final Widget child;

  const EventBusListener({
    super.key,
    required this.eventName,
    required this.onEvent,
    required this.child,
  });

  @override
  State<EventBusListener> createState() => _EventBusListenerState();
}

class _EventBusListenerState extends State<EventBusListener> with AutoDisposeMixin {

  @override
  void initState() {
    super.initState();
    autoDisposeWorker(EventBus().listen(widget.eventName, (data) {
      if(mounted){
        widget.onEvent.call(context, data);
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
