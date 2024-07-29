import 'package:flutter/material.dart';

///重复执行的动画控件
class RepeatAnimatedBuilder extends StatefulWidget {
  final double? value;
  final Duration? duration;
  final double lowerBound;
  final double upperBound;
  final bool reverse;
  final Widget Function(BuildContext context, double value, Widget? child) builder;
  final Widget? child;
  final bool isAnimating;

  const RepeatAnimatedBuilder({
    super.key,
    this.value,
    this.duration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.reverse = false,
    this.child,
    required this.builder,
    this.isAnimating = true,
  });

  @override
  State<RepeatAnimatedBuilder> createState() =>
      _RepeatAnimatedBuilderState();
}

class _RepeatAnimatedBuilderState extends State<RepeatAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.value,
      duration: widget.duration,
      lowerBound: widget.lowerBound,
      upperBound: widget.upperBound,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    if(widget.isAnimating){
      _controller.repeat(reverse: widget.reverse);
    }
  }

  @override
  void didUpdateWidget(covariant RepeatAnimatedBuilder oldWidget) {
    if(widget.isAnimating != oldWidget.isAnimating){
      if(widget.isAnimating && !_controller.isAnimating){
          _controller.repeat(reverse: widget.reverse);
      }else if(!widget.isAnimating && _controller.isAnimating){
        _controller.stop(canceled: false);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => widget.builder(
        context,
        _animation.value,
        child,
      ),
    );
  }
}
