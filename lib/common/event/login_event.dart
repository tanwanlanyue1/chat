
import 'dart:async';

///登录，登出 事件
class LoginEvent{

  static final _streamController = StreamController<LoginEvent>.broadcast();

  ///事件流
  static Stream<LoginEvent> get stream => _streamController.stream;

  ///授权状态
  final bool isLogin;

  ///登录，登出 事件
  LoginEvent(this.isLogin);

  ///发出事件
  void emit(){
    _streamController.add(this);
  }

}
