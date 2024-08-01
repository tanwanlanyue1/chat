import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';

///获取验证码按钮
class LoginVerificationCodeButton extends StatefulWidget {
  final Future<bool> Function() onFetch;
  final bool isInitCountdown;

  ///- onFetch 获取验证码请求
  ///- isInitCountdown 是否在初始化时就开始倒计时
  const LoginVerificationCodeButton({Key? key,required this.onFetch, this.isInitCountdown = false}) : super(key: key);

  @override
  State<LoginVerificationCodeButton> createState() => _LoginVerificationCodeButtonState();
}

class _LoginVerificationCodeButtonState extends State<LoginVerificationCodeButton> {
  bool loading = false;
  bool get enabled => (countdown.secondsRx() == null || countdown.secondsRx() == 0) && !loading;
  _Countdown get countdown => _Countdown.getInstance(widget.key);

  @override
  void initState() {
    super.initState();
    if(widget.isInitCountdown){
      countdown.start();
    }
  }

  ///获取短信验证码
  void fetchData() async {
    try{
      if(loading){
        return;
      }
      loading = true;
      final result = await widget.onFetch();
      if(result){
        countdown..stop()..start();
      }
    }catch(ex){
      debugPrint('获取短信验证码发生错误，ex=$ex');
    }
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      final seconds = countdown.secondsRx();
      var text = (seconds ?? 0) == 0 ? S.current.getCode : S.current.resend;
      if ((seconds ?? 0) > 0) {
        text += ' ($seconds)';
      }
      return GestureDetector(
        onTap: enabled ? fetchData : null,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 46.rpx,
          padding: EdgeInsets.only(right: 12.rpx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.rpx,
                  color: enabled ? AppColor.primary : Color(0xff999999),
                  height: 1.3,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

}

class _Countdown{
  _Countdown._();
  static final _cacheMap = <Key,_Countdown>{};

  static _Countdown getInstance([Key? key]){
    final k = key ?? const Key('default');
    return _cacheMap.putIfAbsent(k, () => _Countdown._());
  }

  final int durationSeconds = 60;
  final secondsRx = Rxn<int>();
  Timer? timer;

  void start() {
    if(timer?.isActive == true){
      return;
    }
    secondsRx.value = durationSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.isActive) {
        secondsRx.value = max(0, (secondsRx()??0) - 1);
        if (secondsRx() == 0) {
          stop();
        }
      }
    });
  }

  void stop() {
    timer?.cancel();
    timer = null;
  }

}
