import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///功德+n显示
class MeritsIncrementView extends StatefulWidget {
  
  ///偏移量
  final Offset offset;
  
  final TextStyle? textStyle;

  const MeritsIncrementView({
    super.key,
    required this.offset,
    this.textStyle,
  });

  @override
  State<MeritsIncrementView> createState() => MeritsIncrementViewState();
}

class MeritsIncrementViewState extends State<MeritsIncrementView> {
  final _ids = <int, Offset>{};
  var text = '';
  final _texts = ['福气+1','好运+1','善哉+1','财运+1','福报+1', '善缘+1'];

  ///加功德特效
  ///- position 偏移量
  ///- value 功德值
  void increment({Offset? position, int? value}) {
    if(value == 0){
      //功德为0不显示
      return;
    }
    setState(() {
      text = '功德+${value??1}';
      _ids.put(
          DateTime.now().millisecondsSinceEpoch, position ?? widget.offset);
    });
  }

  ///加功德特效(随机值)
  ///- position 偏移量
  void incrementRandom({Offset? position}) {
    setState(() {
      text = _texts[Random().nextInt(_texts.length)];
      _ids.put(
          DateTime.now().millisecondsSinceEpoch, position ?? widget.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: _ids.keys.map((item) {
          final position = _ids[item] ?? widget.offset;
          return Positioned(
            key: Key(item.toString()),
            top: position.dy,
            left: position.dx,
            child: MeritsAnimatedView(
              key: Key(item.toString()),
              text: text,
              textStyle: widget.textStyle,
              onEnd: () {
                _ids.remove(item);
              },
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class MeritsAnimatedView extends StatefulWidget {
  final VoidCallback? onEnd;
  final TextStyle? textStyle;
  final String text;

  const MeritsAnimatedView({super.key, this.onEnd, this.textStyle, required this.text});

  @override
  State<MeritsAnimatedView> createState() => _MeritsAnimatedViewState();
}

class _MeritsAnimatedViewState extends State<MeritsAnimatedView>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> transform;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onEnd?.call();
      }
    });
    scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.decelerate,
        ),
      ),
    );
    transform = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.3,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle.fs24m
        .copyWith(fontWeight: FontWeight.bold, color: Colors.white)
        .merge(widget.textStyle);
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.scale(
          scale: scale.value,
          child: Transform.translate(
            offset: Offset(0, transform.value * -100.rpx),
            child: DefaultTextStyle(
              style: textStyle.copyWith(
                color: textStyle.color?.withOpacity(1 - transform.value),
              ),
              child: Text(widget.text),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
