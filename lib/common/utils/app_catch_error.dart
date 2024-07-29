
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///全局异常的捕捉
class AppCatchError {

  static run(VoidCallback runnable) {
    if(kReleaseMode){
      runnable.call();
    }else{
      //flutter 框架异常
      // FlutterError.onError = FlutterError.dumpErrorToConsole;
      //全局异常捕获
      runZonedGuarded(runnable, (error, stack){
        AppLogger.e('AppCatchError:', error: error, stackTrace: stack);
      });
    }
  }
}
