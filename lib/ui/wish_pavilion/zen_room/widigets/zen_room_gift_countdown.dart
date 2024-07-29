import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

///供品倒计时
class ZenRoomGiftCountdown extends StatefulWidget {

  ///结束时间
  final DateTime endTime;

  ///倒计时结束回调
  final VoidCallback? onFinish;

  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const ZenRoomGiftCountdown({
    super.key,
    required this.endTime,
    this.textStyle,
    this.textAlign,
    this.onFinish,
  });

  @override
  State<ZenRoomGiftCountdown> createState() => _ZenRoomGiftCountdownState();
}

class _ZenRoomGiftCountdownState extends State<ZenRoomGiftCountdown> {
  var text = '';
  Timer? ticker;

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
    }else{
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
    if(days > 0){
      text = '$days天 ';
    }
    if(hours > 0){
      text += '${fmt(hours % 24)}:';
    }
    if(minutes > 0 || seconds > 0){
      text += '${fmt(minutes % 60)}:';
    }
    if(seconds > 0){
      text += fmt(seconds % 60);
    }
    setState(() {});
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(text.isEmpty){
      return Spacing.blank;
    }
    return Text(
      text,
      textAlign: widget.textAlign ?? TextAlign.center,
      style: widget.textStyle ?? TextStyle(
        fontSize: 10.rpx,
        color: AppColor.gold
      ),
    );
  }
}
