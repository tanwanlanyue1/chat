import 'dart:async';
import 'package:flutter/material.dart';


///倒计时控件
class CountdownBuilder extends StatefulWidget {
  ///结束时间
  final DateTime endTime;

  ///倒计时结束回调
  final VoidCallback? onFinish;

  final Widget Function(Duration duration, String text) builder;

  const CountdownBuilder({
    super.key,
    required this.endTime,
    required this.builder,
    this.onFinish,
  });

  @override
  State<CountdownBuilder> createState() => _CountdownBuilderState();
}

class _CountdownBuilderState extends State<CountdownBuilder> {
  var text = '';
  Timer? ticker;
  Duration? duration;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => onTick());
    super.initState();
  }

  void onTick() {
    var now = DateTime.now();
    final diff = widget.endTime.difference(now);
    if (diff.isNegative) {
      widget.onFinish?.call();
    } else {
      ticker = Timer(Duration(milliseconds: 1000 - now.millisecond), onTick);
      computeDateText(diff);
    }
  }

  void computeDateText(Duration diff) {
    String fmt(int value) {
      return value.toString().padLeft(2, '0');
    }

    final days = diff.inDays;
    final hours = diff.inHours;
    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds;

    text = '';
    if (days > 0) {
      text = '$days天 ';
    }
    if (hours > 0) {
      text += '${fmt(hours % 24)}:';
    }
    if (minutes > 0 || seconds > 0) {
      text += '${fmt(minutes % 60)}:';
    }
    if (seconds > 0) {
      text += fmt(seconds % 60);
    }
    duration = diff;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(duration ?? Duration.zero, text);
  }
}
