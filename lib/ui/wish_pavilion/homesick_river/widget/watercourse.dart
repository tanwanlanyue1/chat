
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';


//水流
class WatercourseWidget extends StatefulWidget {
  final Offset startPoint;
  final Widget child;
  final int index;
  const WatercourseWidget({super.key, required this.startPoint,required this.child,required this.index});

  @override
  _WatercourseWidgetState createState() => _WatercourseWidgetState();
}

class _WatercourseWidgetState extends State<WatercourseWidget> with SingleTickerProviderStateMixin {
  late List<Offset> _points;
  //默认1
  final List<Offset> _defaultOnes =[
    const Offset(200,-80),
    const Offset(200,-60),
    const Offset(200,0),
    const Offset(246,50),
    const Offset(160, 80),
    const Offset(180, 140),
    const Offset(230, 200),
    const Offset(160, 230),
    const Offset(110, 250),
    const Offset(60, 290),
    const Offset(140, 320),
    const Offset(210, 350),
    const Offset(210, 384),
    const Offset(210, 400),
    const Offset(180, 404),
    const Offset(120, 420),
    const Offset(140, 460),
    const Offset(100, 520),
    const Offset(40, 560),
  ];
  //默认1
  final List<Offset> _defaultOne =[
    const Offset(200,-80),
    const Offset(200,-60),
    const Offset(200,0),
    const Offset(246,50),
    const Offset(160, 80),
    const Offset(180, 140),
    const Offset(230, 200),
    const Offset(160, 230),
    const Offset(110, 250),
    const Offset(60, 290),
    const Offset(140, 320),
    const Offset(210, 350),
    const Offset(210, 384),
    const Offset(180, 390),
    const Offset(120, 400),
    const Offset(140, 460),
    const Offset(80, 520),
    const Offset(40, 560),
  ];
  //默认2
  final List<Offset> _defaultTwo =[
    const Offset(200,-80),
    const Offset(200,-60),
    const Offset(200,0),
    const Offset(246,50),
    const Offset(160, 80),
    const Offset(180, 140),
    const Offset(230, 200),
    const Offset(160, 230),
    const Offset(80, 250),
    const Offset(60, 290),
    const Offset(140, 320),
    const Offset(210, 350),
    const Offset(210, 384),
    const Offset(180, 390),
    const Offset(120, 400),
    const Offset(120, 460),
    const Offset(140, 520),
    const Offset(160, 580),
  ];
  //默认3
  final List<Offset> _defaultThree =[
    const Offset(200,-80),
    const Offset(200,-60),
    const Offset(200,0),
    const Offset(246,50),
    const Offset(160, 80),
    const Offset(180, 140),
    const Offset(230, 200),
    const Offset(160, 230),
    const Offset(80, 250),
    const Offset(60, 290),
    const Offset(140, 320),
    const Offset(210, 350),
    const Offset(210, 384),
    const Offset(180, 390),
    const Offset(120, 400),
    const Offset(120, 460),
    const Offset(140, 520),
    const Offset(220, 550),
    const Offset(260, 580),
  ];
  //默认4
  final List<Offset> _defaultFour =[
    const Offset(200,-80),
    const Offset(200,-60),
    const Offset(200,0),
    const Offset(246,50),
    const Offset(160, 80),
    const Offset(180, 140),
    const Offset(230, 200),
    const Offset(160, 230),
    const Offset(110, 250),
    const Offset(60, 290),
    const Offset(140, 320),
    const Offset(210, 350),
    const Offset(220, 396),
    const Offset(180, 400),
    const Offset(120, 420),
    const Offset(160, 460),
    const Offset(120, 520),
    const Offset(40, 560),
  ];
  int _currentPointIndex = 0;
  double _scale = 1.0;
  double _opacity = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    if(widget.index == 3 || widget.index == 4){
      _points = _defaultOnes;
    } else if (widget.index == 3 || widget.index == 4) {
      _points = _defaultFour;
    } else if (widget.index % 2 == 0) {
      _points = _defaultOne;
    } else if (widget.index % 3 == 0) {
      _points = _defaultTwo;
    } else {
      _points = _defaultThree;
    }
    _currentPointIndex = _points.indexOf(widget.startPoint);
    if (_currentPointIndex == -1) {
      _currentPointIndex = 0;
    }
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
    setState(() {
      if (_currentPointIndex < _points.length - 1) {
        _currentPointIndex++;
        _scale -= 0.05;
        if (_currentPointIndex == _points.length - 1) {
          _opacity = 0.0;
        }
        _controller.forward(from: 0);
      } else {
        _controller.stop();
      }
    });
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
          left: _points[_currentPointIndex].dx.rpx,
          bottom: _points[_currentPointIndex].dy.rpx,
          duration: _controller.duration!,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0, end: _scale),
            duration: const Duration(seconds: 1),
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
        ),
      ],
    );
  }
}