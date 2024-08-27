import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///路由监听
class AppRouteObserver extends RouteObserver<ModalRoute<void>> {

  final _stack = <Route<dynamic>>[];

  ///路由导航栈
  List<Route<dynamic>> get stack => List.of(_stack);

  //跳转到新页面
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _stack.insert(0, route);
    AppLogger.d('RouteObserver > didPush > ${_stack}');
  }

  //关闭页面
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _stack.remove(route);
    AppLogger.d('RouteObserver > didPop > ${_stack}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = _stack.indexWhere((element) {
        return element == oldRoute;
      });
      if (index >= 0) {
        _stack[index] = newRoute;
      } else {
        _stack.insert(0, newRoute);
      }
    }
    AppLogger.d('RouteObserver > didReplace > ${_stack}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _stack.remove(route);
    AppLogger.d('RouteObserver > didRemove > ${_stack}');
  }

}
