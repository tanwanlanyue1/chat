// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `语言`
  String get language {
    return Intl.message(
      '语言',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get setting {
    return Intl.message(
      '设置',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get personalInformation {
    return Intl.message(
      '个人信息',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `我的钱包`
  String get myWallet {
    return Intl.message(
      '我的钱包',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `我的VIP`
  String get myVIP {
    return Intl.message(
      '我的VIP',
      name: 'myVIP',
      desc: '',
      args: [],
    );
  }

  /// `我的评价`
  String get myAssessment {
    return Intl.message(
      '我的评价',
      name: 'myAssessment',
      desc: '',
      args: [],
    );
  }

  /// `意见反馈`
  String get feedback {
    return Intl.message(
      '意见反馈',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `我的设置`
  String get mySettings {
    return Intl.message(
      '我的设置',
      name: 'mySettings',
      desc: '',
      args: [],
    );
  }

  /// `激活/进阶`
  String get activationProgression {
    return Intl.message(
      '激活/进阶',
      name: 'activationProgression',
      desc: '',
      args: [],
    );
  }

  /// `我的消息`
  String get myMessage {
    return Intl.message(
      '我的消息',
      name: 'myMessage',
      desc: '',
      args: [],
    );
  }

  /// `我的客户`
  String get myCustomer {
    return Intl.message(
      '我的客户',
      name: 'myCustomer',
      desc: '',
      args: [],
    );
  }

  /// `解约/进阶为经纪人`
  String get cancelAdvanceToBroker {
    return Intl.message(
      '解约/进阶为经纪人',
      name: 'cancelAdvanceToBroker',
      desc: '',
      args: [],
    );
  }

  /// `评价我的`
  String get appraiseMe {
    return Intl.message(
      '评价我的',
      name: 'appraiseMe',
      desc: '',
      args: [],
    );
  }

  /// `谁看过我`
  String get whoSeenMe {
    return Intl.message(
      '谁看过我',
      name: 'whoSeenMe',
      desc: '',
      args: [],
    );
  }

  /// `修改服务费`
  String get modificationServiceCharge {
    return Intl.message(
      '修改服务费',
      name: 'modificationServiceCharge',
      desc: '',
      args: [],
    );
  }

  /// `查看契约单`
  String get viewSheet {
    return Intl.message(
      '查看契约单',
      name: 'viewSheet',
      desc: '',
      args: [],
    );
  }

  /// `登 录`
  String get login {
    return Intl.message(
      '登 录',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `您好，\n欢迎回来！`
  String get loginWelcome {
    return Intl.message(
      '您好，\n欢迎回来！',
      name: 'loginWelcome',
      desc: '',
      args: [],
    );
  }

  /// `账号`
  String get loginAccount {
    return Intl.message(
      '账号',
      name: 'loginAccount',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get loginPassword {
    return Intl.message(
      '密码',
      name: 'loginPassword',
      desc: '',
      args: [],
    );
  }

  /// `忘记密码？`
  String get loginForgetPassword {
    return Intl.message(
      '忘记密码？',
      name: 'loginForgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `还没有账号？马上注册`
  String get loginRegister {
    return Intl.message(
      '还没有账号？马上注册',
      name: 'loginRegister',
      desc: '',
      args: [],
    );
  }

  /// `注册`
  String get register {
    return Intl.message(
      '注册',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `注 册`
  String get registerSpace {
    return Intl.message(
      '注 册',
      name: 'registerSpace',
      desc: '',
      args: [],
    );
  }

  /// `请输入用户名`
  String get registerAccountHint {
    return Intl.message(
      '请输入用户名',
      name: 'registerAccountHint',
      desc: '',
      args: [],
    );
  }

  /// `请设置6-20位登录密码`
  String get registerPasswordHint {
    return Intl.message(
      '请设置6-20位登录密码',
      name: 'registerPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `请再次确认登陆密码`
  String get registerPasswordAgainHint {
    return Intl.message(
      '请再次确认登陆密码',
      name: 'registerPasswordAgainHint',
      desc: '',
      args: [],
    );
  }

  /// `+1 194-351-2685（手机号码选填）`
  String get registerPhoneHint {
    return Intl.message(
      '+1 194-351-2685（手机号码选填）',
      name: 'registerPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的邮箱（选填）`
  String get registerEmailHint {
    return Intl.message(
      '请输入您的邮箱（选填）',
      name: 'registerEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `已有账号？去登录`
  String get registerLogin {
    return Intl.message(
      '已有账号？去登录',
      name: 'registerLogin',
      desc: '',
      args: [],
    );
  }

  /// `点击注册默认同意`
  String get registerAgreement {
    return Intl.message(
      '点击注册默认同意',
      name: 'registerAgreement',
      desc: '',
      args: [],
    );
  }

  /// `用户协议`
  String get webUser {
    return Intl.message(
      '用户协议',
      name: 'webUser',
      desc: '',
      args: [],
    );
  }

  /// `忘记密码？`
  String get forgotTitle {
    return Intl.message(
      '忘记密码？',
      name: 'forgotTitle',
      desc: '',
      args: [],
    );
  }

  /// `重置密码`
  String get forgotNextTitle {
    return Intl.message(
      '重置密码',
      name: 'forgotNextTitle',
      desc: '',
      args: [],
    );
  }

  /// `请在下面输入您的电子邮件已接收密码重置邮件？`
  String get forgotTitleTip {
    return Intl.message(
      '请在下面输入您的电子邮件已接收密码重置邮件？',
      name: 'forgotTitleTip',
      desc: '',
      args: [],
    );
  }

  /// `重置代码发送到您的电子邮件。请输入代码并创建新密码`
  String get forgotNextTitleTip {
    return Intl.message(
      '重置代码发送到您的电子邮件。请输入代码并创建新密码',
      name: 'forgotNextTitleTip',
      desc: '',
      args: [],
    );
  }

  /// `邮箱地址`
  String get forgotEmailHint {
    return Intl.message(
      '邮箱地址',
      name: 'forgotEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `重置代码`
  String get forgotCodeHint {
    return Intl.message(
      '重置代码',
      name: 'forgotCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `新的密码`
  String get forgotPasswordHint {
    return Intl.message(
      '新的密码',
      name: 'forgotPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `确认密码`
  String get forgotPasswordAgainHint {
    return Intl.message(
      '确认密码',
      name: 'forgotPasswordAgainHint',
      desc: '',
      args: [],
    );
  }

  /// `发 送`
  String get forgotSend {
    return Intl.message(
      '发 送',
      name: 'forgotSend',
      desc: '',
      args: [],
    );
  }

  /// `更改密码`
  String get forgotResetPassword {
    return Intl.message(
      '更改密码',
      name: 'forgotResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `跳过`
  String get questionSkip {
    return Intl.message(
      '跳过',
      name: 'questionSkip',
      desc: '',
      args: [],
    );
  }

  /// `欢迎使用管佳！`
  String get questionWelcome {
    return Intl.message(
      '欢迎使用管佳！',
      name: 'questionWelcome',
      desc: '',
      args: [],
    );
  }

  /// `现在我们有{count}个问题可以帮助您找到更为 合您心意的佳丽`
  String questionTip(Object count) {
    return Intl.message(
      '现在我们有$count个问题可以帮助您找到更为 合您心意的佳丽',
      name: 'questionTip',
      desc: '',
      args: [count],
    );
  }

  /// `马上开始`
  String get questionBegin {
    return Intl.message(
      '马上开始',
      name: 'questionBegin',
      desc: '',
      args: [],
    );
  }

  /// `男士`
  String get questionMan {
    return Intl.message(
      '男士',
      name: 'questionMan',
      desc: '',
      args: [],
    );
  }

  /// `女士`
  String get questionWoman {
    return Intl.message(
      '女士',
      name: 'questionWoman',
      desc: '',
      args: [],
    );
  }

  /// `完 成`
  String get questionFinish {
    return Intl.message(
      '完 成',
      name: 'questionFinish',
      desc: '',
      args: [],
    );
  }

  /// `您喜欢的对象是？`
  String get questionGenderLike {
    return Intl.message(
      '您喜欢的对象是？',
      name: 'questionGenderLike',
      desc: '',
      args: [],
    );
  }

  /// `您比较偏爱的风格是什么？`
  String get questionLabelsLike {
    return Intl.message(
      '您比较偏爱的风格是什么？',
      name: 'questionLabelsLike',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
