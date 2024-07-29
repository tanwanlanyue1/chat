
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/widgets/loading.dart';

///APP退出确认提醒消息(只针对Android做提醒)
class AppExitConfirm extends StatelessWidget {
  final String message;
  final Widget child;
  static const _delayMs = 2000;
  static var _lastMs = 0;
  const AppExitConfirm({super.key, required this.child, this.message = '再按一次退出'});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !Platform.isAndroid,
      onPopInvoked: (canPop){
        if(canPop){
          return;
        }
        final now = DateTime.now().millisecondsSinceEpoch;
        if(_lastMs == 0 || (now - _lastMs) > _delayMs){
          _lastMs = now;
          Loading.showToast(message);
          return;
        }
        _lastMs = 0;
        SystemNavigator.pop();
      },
      child: child,
    );
  }
}
