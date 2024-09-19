
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/recaptcha_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../firebase_options.dart';
import '../network/api/open_api.dart';
import 'app_logger.dart';

///firebase 帮助类
class FirebaseUtil{
  FirebaseUtil._();
  static final instance = FirebaseUtil._();
  factory FirebaseUtil() => instance;

  ///初始化firebase
  Future<void> init() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      setFcmTokenToServer();
    });
  }


  ///发送短信验证码
  ///- phoneNumber 手机号，需要代国家编码，例如：+86 18678765654
  ///- return 返回验证ID verificationId
  Future<String?> sendSmsCode(String phoneNumber) async{
    final completer = Completer<String?>();

    //人机校验
    if(AppConfig.recaptchaPhoneEnable){
      final recaptchaToken = await ReCaptchaDialog.show();
      if(recaptchaToken == null){
        //用户取消校验
        return null;
      }

      //接口校验token
      Loading.show();
      final resp = await OpenApi.recaptchaVerify(recaptchaToken);
      if(!resp.isSuccess){
        Loading.dismiss();
        resp.showErrorMessage();
        return null;
      }
    }

    Loading.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async{
        AppLogger.d('verificationCompleted: $credential');
      },
      verificationFailed: (FirebaseAuthException e) {
        AppLogger.d('verificationFailed: $e');
        completer.complete(null);
      },
      codeSent: (String verificationId, int? resendToken) async{
        AppLogger.d('codeSent: verificationId=$verificationId, resendToken=$resendToken');
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        AppLogger.d('codeAutoRetrievalTimeout: $verificationId');
      },
    );
    String? verificationId;
    try{
      verificationId = await completer.future;
    }catch(ex){
      AppLogger.w(ex);
    }

    Loading.dismiss();
    if(verificationId == null){
      Loading.showToast('验证码发送失败');
    }

    return verificationId;
  }

  ///验证短信验证码
  ///- verificationId 验证ID
  ///- smsCode 短信验证码
  ///- return 返回 idToken
  Future<String?> verifySmsCode(String verificationId, String smsCode) async{
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      return result.user?.getIdToken(true);
    }catch(ex){
      AppLogger.w('verifySmsCode: $ex');
    }
    return null;
  }

  ///设置fcm token到服务端
  Future<void> setFcmTokenToServer() async {
    final token = await FirebaseMessaging.instance.getToken();
    AppLogger.d('setFcmTokenToServer: $token');
    if(token != null && SS.login.isLogin){
      await OpenApi.updatePushId(token);
    }
  }

}