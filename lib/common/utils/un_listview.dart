import 'package:flutter/material.dart';

//去除ListView水波纹
class ChatScrollBehavior extends ScrollBehavior {

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

