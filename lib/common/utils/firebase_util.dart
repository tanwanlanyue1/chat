
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

import '../firebase_options.dart';
import 'app_logger.dart';

///firebase 帮助类
class FirebaseUtil{
  FirebaseUtil._();
  static final instance = FirebaseUtil._();
  factory FirebaseUtil() => instance;

  RecaptchaClient? _recaptchaClient;

  ///初始化firebase
  Future<void> init() async{
    await Future.wait([
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ]);
  }


  ///发送短信验证码
  ///- phoneNumber 手机号，需要代国家编码，例如：+86 18678765654
  ///- return 返回验证ID verificationId
  Future<String?> sendSmsCode(String phoneNumber) async{
    final completer = Completer<String?>();

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
    try{
      return await completer.future.timeout(const Duration(seconds: 10));
    }catch(ex){
      return null;
    }
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

}