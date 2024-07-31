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

  /// `管佳`
  String get appName {
    return Intl.message(
      '管佳',
      name: 'appName',
      desc: '',
      args: [],
    );
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

  /// `生成契约单`
  String get generateContract {
    return Intl.message(
      '生成契约单',
      name: 'generateContract',
      desc: '',
      args: [],
    );
  }

  /// `甲方：`
  String get partyA {
    return Intl.message(
      '甲方：',
      name: 'partyA',
      desc: '',
      args: [],
    );
  }

  /// `乙方：`
  String get partyB {
    return Intl.message(
      '乙方：',
      name: 'partyB',
      desc: '',
      args: [],
    );
  }

  /// `选择好友绑定`
  String get selectFriendBinding {
    return Intl.message(
      '选择好友绑定',
      name: 'selectFriendBinding',
      desc: '',
      args: [],
    );
  }

  /// `时间：`
  String get contractDate {
    return Intl.message(
      '时间：',
      name: 'contractDate',
      desc: '',
      args: [],
    );
  }

  /// `修改契约单模板`
  String get contractEdit {
    return Intl.message(
      '修改契约单模板',
      name: 'contractEdit',
      desc: '',
      args: [],
    );
  }

  /// `立即推送契约单`
  String get contractPush {
    return Intl.message(
      '立即推送契约单',
      name: 'contractPush',
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
