import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class LanternWidget extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  const LanternWidget({super.key, required this.currentIndex, required this.child,});

  @override
  _LanternWidgetState createState() => _LanternWidgetState();
}

class _LanternWidgetState extends State<LanternWidget> with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];
  final random = Random();

  List<Offset> values = [const Offset(30,150), const Offset(10,300), const Offset(50,380), const Offset(40,450)];
  //坐标下标
  int _currentPointIndex = 0;
  double _scale = 0.2;
  double _littleScale = 1;
  double _opacity = 1.0;
  //动画
  int positDuration = 3;
  //传递进来的下标
  int currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    Offset curr = values[currentIndex % values.length];
    _points.insert(0, curr);
    _randomOffset();
    if(currentIndex % values.length == 0){
      positDuration = 14;
    }else if(currentIndex % values.length == 1){
      positDuration = 12;
    }else if(currentIndex % values.length == 2){
      positDuration = 10;
    }else if(currentIndex % values.length == 3){
      positDuration = 8;
    }
    _scale += 0.5;
    _controller = AnimationController(
      duration: Duration(seconds: positDuration),
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _onAnimationEnd();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onAnimationEnd();
    });
  }

  void _onAnimationEnd() {
    Future.delayed(const Duration(seconds: 1),(){
      if (_currentPointIndex < _points.length - 1) {
        if(mounted){
          setState(() {
            _currentPointIndex++;
          });
        }
      }
      if(_currentPointIndex == _points.length - 1){
        int mill = (positDuration*0.6*1000).truncate();
        Future.delayed( Duration(milliseconds: mill),(){
          if(mounted){
            setState(() {
              _opacity = 0.0;
              _littleScale = 0;
            });
          }
        });
      }
     if(mounted){
       _onAnimationEnd();
     }
    });
  }

  //随机坐标
  void _randomOffset(){
    late Offset _randomOffsets;
    final Random random = Random();
    double previousY = _points[0].dy;
    double x = random.nextDouble() * (200 - 10) + 10;
    double x1 = random.nextDouble() * (200 - 10) + 10;
    double y = random.nextDouble() * (600 - previousY) + previousY;
    _randomOffsets = Offset(x, y);
    previousY = y;
    _points.add(_randomOffsets);
    _points.add(Offset(x1, 650));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          left: currentIndex % 2 == 0 ? _points[_currentPointIndex].dx.rpx : null,
          right: currentIndex % 2 != 0 ? _points[_currentPointIndex].dx.rpx : null,
          bottom: _points[_currentPointIndex].dy.rpx,
          duration: _controller.duration!,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: _scale),
            duration: const Duration(seconds: 4),
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.scale(
                scale: value,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 1, end: _littleScale),
                  duration: const Duration(seconds: 4),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.scale(
                      scale: value,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 1.0, end: _opacity),
                        duration: const Duration(seconds: 3),
                        builder: (BuildContext context, double value, Widget? child) {
                          return Opacity(
                            opacity: value,
                            child: child,
                          );
                        },
                        child: widget.child,
                      ),
                    );
                  },
                  child: widget.child,
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }
}