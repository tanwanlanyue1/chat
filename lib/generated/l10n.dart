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

  /// `团队评价`
  String get teamEvaluation {
    return Intl.message(
      '团队评价',
      name: 'teamEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `我的团队`
  String get myTeam {
    return Intl.message(
      '我的团队',
      name: 'myTeam',
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

  /// `客户`
  String get customer {
    return Intl.message(
      '客户',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `您好，请选择标签`
  String get pleaseSelectATag {
    return Intl.message(
      '您好，请选择标签',
      name: 'pleaseSelectATag',
      desc: '',
      args: [],
    );
  }

  /// `具体建议内容`
  String get specificProposalContent {
    return Intl.message(
      '具体建议内容',
      name: 'specificProposalContent',
      desc: '',
      args: [],
    );
  }

  /// `上传图片`
  String get uploadPictures {
    return Intl.message(
      '上传图片',
      name: 'uploadPictures',
      desc: '',
      args: [],
    );
  }

  /// `VIP制度`
  String get VIPSystem {
    return Intl.message(
      'VIP制度',
      name: 'VIPSystem',
      desc: '',
      args: [],
    );
  }

  /// `服务流程`
  String get serviceProcess {
    return Intl.message(
      '服务流程',
      name: 'serviceProcess',
      desc: '',
      args: [],
    );
  }

  /// `活动营销`
  String get activeMarketing {
    return Intl.message(
      '活动营销',
      name: 'activeMarketing',
      desc: '',
      args: [],
    );
  }

  /// `售后服务`
  String get afterSalesService {
    return Intl.message(
      '售后服务',
      name: 'afterSalesService',
      desc: '',
      args: [],
    );
  }

  /// `我要投诉`
  String get iHaveAComplaint {
    return Intl.message(
      '我要投诉',
      name: 'iHaveAComplaint',
      desc: '',
      args: [],
    );
  }

  /// `请输入建议内容`
  String get pleaseEnterASuggestion {
    return Intl.message(
      '请输入建议内容',
      name: 'pleaseEnterASuggestion',
      desc: '',
      args: [],
    );
  }

  /// `其他`
  String get other {
    return Intl.message(
      '其他',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `联系电话`
  String get contactNumber {
    return Intl.message(
      '联系电话',
      name: 'contactNumber',
      desc: '',
      args: [],
    );
  }

  /// `请填写您的手机号码或邮箱，便于与您联系(选填)`
  String get pleaseFillInYourMobilePhoneNumber {
    return Intl.message(
      '请填写您的手机号码或邮箱，便于与您联系(选填)',
      name: 'pleaseFillInYourMobilePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `震动提醒`
  String get vibrationReminder {
    return Intl.message(
      '震动提醒',
      name: 'vibrationReminder',
      desc: '',
      args: [],
    );
  }

  /// `铃声提醒`
  String get bellReminder {
    return Intl.message(
      '铃声提醒',
      name: 'bellReminder',
      desc: '',
      args: [],
    );
  }

  /// `修改登录密码`
  String get changingPassword {
    return Intl.message(
      '修改登录密码',
      name: 'changingPassword',
      desc: '',
      args: [],
    );
  }

  /// `设置支付密码`
  String get setPaymentPassword {
    return Intl.message(
      '设置支付密码',
      name: 'setPaymentPassword',
      desc: '',
      args: [],
    );
  }

  /// `修改支付密码`
  String get changingPaymentPassword {
    return Intl.message(
      '修改支付密码',
      name: 'changingPaymentPassword',
      desc: '',
      args: [],
    );
  }

  /// `语言切换`
  String get languageSwitch {
    return Intl.message(
      '语言切换',
      name: 'languageSwitch',
      desc: '',
      args: [],
    );
  }

  /// `清空缓存`
  String get clearCache {
    return Intl.message(
      '清空缓存',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `检测新版本`
  String get detectNewVersions {
    return Intl.message(
      '检测新版本',
      name: 'detectNewVersions',
      desc: '',
      args: [],
    );
  }

  /// `版本`
  String get versions {
    return Intl.message(
      '版本',
      name: 'versions',
      desc: '',
      args: [],
    );
  }

  /// `粤ICP备2024188839号`
  String get guangdongICP {
    return Intl.message(
      '粤ICP备2024188839号',
      name: 'guangdongICP',
      desc: '',
      args: [],
    );
  }

  /// `关于我们`
  String get aboutUs {
    return Intl.message(
      '关于我们',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `手机验证码将发送到`
  String get phoneVerificationCode {
    return Intl.message(
      '手机验证码将发送到',
      name: 'phoneVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `手机上，请注意查收`
  String get cellPhone {
    return Intl.message(
      '手机上，请注意查收',
      name: 'cellPhone',
      desc: '',
      args: [],
    );
  }

  /// `邮箱验证码将发送到`
  String get emailVerificationCode {
    return Intl.message(
      '邮箱验证码将发送到',
      name: 'emailVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `邮箱上，请注意查收`
  String get cellEmail {
    return Intl.message(
      '邮箱上，请注意查收',
      name: 'cellEmail',
      desc: '',
      args: [],
    );
  }

  /// `收不到验证码`
  String get notReceiveTheVerification {
    return Intl.message(
      '收不到验证码',
      name: 'notReceiveTheVerification',
      desc: '',
      args: [],
    );
  }

  /// `换个验证方式`
  String get changeVerificationMethod {
    return Intl.message(
      '换个验证方式',
      name: 'changeVerificationMethod',
      desc: '',
      args: [],
    );
  }

  /// `手机验证码`
  String get cellPhoneVerificationCode {
    return Intl.message(
      '手机验证码',
      name: 'cellPhoneVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `邮箱验证码`
  String get cellEmailVerificationCode {
    return Intl.message(
      '邮箱验证码',
      name: 'cellEmailVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `请输入验证码`
  String get pleaseEnterTheVerificationCode {
    return Intl.message(
      '请输入验证码',
      name: 'pleaseEnterTheVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `获取验证码`
  String get getCode {
    return Intl.message(
      '获取验证码',
      name: 'getCode',
      desc: '',
      args: [],
    );
  }

  /// `重新发送`
  String get resend {
    return Intl.message(
      '重新发送',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `请输入密码`
  String get enterYourPIN {
    return Intl.message(
      '请输入密码',
      name: 'enterYourPIN',
      desc: '',
      args: [],
    );
  }

  /// `请输入6-20位字符`
  String get pleaseEnter620Characters {
    return Intl.message(
      '请输入6-20位字符',
      name: 'pleaseEnter620Characters',
      desc: '',
      args: [],
    );
  }

  /// `请确认密码`
  String get pleaseConfirmThePassword {
    return Intl.message(
      '请确认密码',
      name: 'pleaseConfirmThePassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入确认密码`
  String get pleaseEnterYourConfirmationPassword {
    return Intl.message(
      '请输入确认密码',
      name: 'pleaseEnterYourConfirmationPassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入支付密码`
  String get pleaseEnterYourPaymentPassword {
    return Intl.message(
      '请输入支付密码',
      name: 'pleaseEnterYourPaymentPassword',
      desc: '',
      args: [],
    );
  }

  /// `请确认支付密码`
  String get confirmPayment {
    return Intl.message(
      '请确认支付密码',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `隐私服务`
  String get privacyService {
    return Intl.message(
      '隐私服务',
      name: 'privacyService',
      desc: '',
      args: [],
    );
  }

  /// `服务协议`
  String get serviceAgreement {
    return Intl.message(
      '服务协议',
      name: 'serviceAgreement',
      desc: '',
      args: [],
    );
  }

  /// `充值服务协议`
  String get rechargeService {
    return Intl.message(
      '充值服务协议',
      name: 'rechargeService',
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

  /// `查看契约单`
  String get contractDetail {
    return Intl.message(
      '查看契约单',
      name: 'contractDetail',
      desc: '',
      args: [],
    );
  }

  /// `签订契约单`
  String get contractSign {
    return Intl.message(
      '签订契约单',
      name: 'contractSign',
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

  /// `立即修改`
  String get updateNow {
    return Intl.message(
      '立即修改',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `未签约`
  String get contractUnsigned {
    return Intl.message(
      '未签约',
      name: 'contractUnsigned',
      desc: '',
      args: [],
    );
  }

  /// `签约中`
  String get contractSigning {
    return Intl.message(
      '签约中',
      name: 'contractSigning',
      desc: '',
      args: [],
    );
  }

  /// `已签约`
  String get contractSigned {
    return Intl.message(
      '已签约',
      name: 'contractSigned',
      desc: '',
      args: [],
    );
  }

  /// `已解除`
  String get contractTerminated {
    return Intl.message(
      '已解除',
      name: 'contractTerminated',
      desc: '',
      args: [],
    );
  }

  /// `拒绝签约`
  String get contractReject {
    return Intl.message(
      '拒绝签约',
      name: 'contractReject',
      desc: '',
      args: [],
    );
  }

  /// `立即签订`
  String get contractSignNow {
    return Intl.message(
      '立即签订',
      name: 'contractSignNow',
      desc: '',
      args: [],
    );
  }

  /// `解除当前契约`
  String get contractTerminateNow {
    return Intl.message(
      '解除当前契约',
      name: 'contractTerminateNow',
      desc: '',
      args: [],
    );
  }

  /// `契约单列表`
  String get contractList {
    return Intl.message(
      '契约单列表',
      name: 'contractList',
      desc: '',
      args: [],
    );
  }

  /// `经纪人：`
  String get broker {
    return Intl.message(
      '经纪人：',
      name: 'broker',
      desc: '',
      args: [],
    );
  }

  /// `经纪人`
  String get brokerP {
    return Intl.message(
      '经纪人',
      name: 'brokerP',
      desc: '',
      args: [],
    );
  }

  /// `佳丽`
  String get goodGirl {
    return Intl.message(
      '佳丽',
      name: 'goodGirl',
      desc: '',
      args: [],
    );
  }

  /// `起止时间：`
  String get startStopTime {
    return Intl.message(
      '起止时间：',
      name: 'startStopTime',
      desc: '',
      args: [],
    );
  }

  /// `起止时间：`
  String get effectiveTime {
    return Intl.message(
      '起止时间：',
      name: 'effectiveTime',
      desc: '',
      args: [],
    );
  }

  /// `暂无`
  String get none {
    return Intl.message(
      '暂无',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `和当前经纪人发起解约?发起后系统将自动向该经纪人发送解约申请。`
  String get contractTerminateHint {
    return Intl.message(
      '和当前经纪人发起解约?发起后系统将自动向该经纪人发送解约申请。',
      name: 'contractTerminateHint',
      desc: '',
      args: [],
    );
  }

  /// `确定解约`
  String get confirmTerminate {
    return Intl.message(
      '确定解约',
      name: 'confirmTerminate',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get confirm {
    return Intl.message(
      '确定',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `确认`
  String get affirm {
    return Intl.message(
      '确认',
      name: 'affirm',
      desc: '',
      args: [],
    );
  }

  /// `身份进阶`
  String get identityProgression {
    return Intl.message(
      '身份进阶',
      name: 'identityProgression',
      desc: '',
      args: [],
    );
  }

  /// `身份进阶审核`
  String get underReview {
    return Intl.message(
      '身份进阶审核',
      name: 'underReview',
      desc: '',
      args: [],
    );
  }

  /// `身份进阶成功`
  String get successfulAudit {
    return Intl.message(
      '身份进阶成功',
      name: 'successfulAudit',
      desc: '',
      args: [],
    );
  }

  /// `审核失败`
  String get auditFailure {
    return Intl.message(
      '审核失败',
      name: 'auditFailure',
      desc: '',
      args: [],
    );
  }

  /// `请选择您想要激活的身份`
  String get pleaseSelectId {
    return Intl.message(
      '请选择您想要激活的身份',
      name: 'pleaseSelectId',
      desc: '',
      args: [],
    );
  }

  /// `申请资料已提交`
  String get dataSubmitted {
    return Intl.message(
      '申请资料已提交',
      name: 'dataSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `请耐心等待，可`
  String get patient {
    return Intl.message(
      '请耐心等待，可',
      name: 'patient',
      desc: '',
      args: [],
    );
  }

  /// `询问客服`
  String get customerService {
    return Intl.message(
      '询问客服',
      name: 'customerService',
      desc: '',
      args: [],
    );
  }

  /// `关注进度`
  String get monitorProgress {
    return Intl.message(
      '关注进度',
      name: 'monitorProgress',
      desc: '',
      args: [],
    );
  }

  /// `已提交`
  String get submitted {
    return Intl.message(
      '已提交',
      name: 'submitted',
      desc: '',
      args: [],
    );
  }

  /// `恭喜您成为`
  String get congratulations {
    return Intl.message(
      '恭喜您成为',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `陪聊收益`
  String get chatRevenue {
    return Intl.message(
      '陪聊收益',
      name: 'chatRevenue',
      desc: '',
      args: [],
    );
  }

  /// `约会收益`
  String get datingIncome {
    return Intl.message(
      '约会收益',
      name: 'datingIncome',
      desc: '',
      args: [],
    );
  }

  /// `经纪团队`
  String get brokerageTeam {
    return Intl.message(
      '经纪团队',
      name: 'brokerageTeam',
      desc: '',
      args: [],
    );
  }

  /// `指派分配`
  String get assignment {
    return Intl.message(
      '指派分配',
      name: 'assignment',
      desc: '',
      args: [],
    );
  }

  /// `团队收益`
  String get teamRevenue {
    return Intl.message(
      '团队收益',
      name: 'teamRevenue',
      desc: '',
      args: [],
    );
  }

  /// `约会邀约`
  String get dateOffer {
    return Intl.message(
      '约会邀约',
      name: 'dateOffer',
      desc: '',
      args: [],
    );
  }

  /// `聊天交友`
  String get chatFriends {
    return Intl.message(
      '聊天交友',
      name: 'chatFriends',
      desc: '',
      args: [],
    );
  }

  /// `用户向您发起语音/视频聊天，可赚取收益`
  String get initiatingCoice {
    return Intl.message(
      '用户向您发起语音/视频聊天，可赚取收益',
      name: 'initiatingCoice',
      desc: '',
      args: [],
    );
  }

  /// `用户与用户参与约会，赚取服务费收益`
  String get goOnDate {
    return Intl.message(
      '用户与用户参与约会，赚取服务费收益',
      name: 'goOnDate',
      desc: '',
      args: [],
    );
  }

  /// `加入专业的经纪团队，肤取更多约会机会`
  String get majorBrokerageTeam {
    return Intl.message(
      '加入专业的经纪团队，肤取更多约会机会',
      name: 'majorBrokerageTeam',
      desc: '',
      args: [],
    );
  }

  /// `用户下单，可指派分配至旗下的佳丽`
  String get userOrder {
    return Intl.message(
      '用户下单，可指派分配至旗下的佳丽',
      name: 'userOrder',
      desc: '',
      args: [],
    );
  }

  /// `参与旗下所有佳丽的约会收益分成`
  String get participationSharing {
    return Intl.message(
      '参与旗下所有佳丽的约会收益分成',
      name: 'participationSharing',
      desc: '',
      args: [],
    );
  }

  /// `选择心仪的佳丽/经纪，并发起约会邀约`
  String get preference {
    return Intl.message(
      '选择心仪的佳丽/经纪，并发起约会邀约',
      name: 'preference',
      desc: '',
      args: [],
    );
  }

  /// `寻找心动对象，愉快的聊天约会吧`
  String get cardiacObject {
    return Intl.message(
      '寻找心动对象，愉快的聊天约会吧',
      name: 'cardiacObject',
      desc: '',
      args: [],
    );
  }

  /// `进阶经纪人/普通用户`
  String get generalUser {
    return Intl.message(
      '进阶经纪人/普通用户',
      name: 'generalUser',
      desc: '',
      args: [],
    );
  }

  /// `进阶佳丽/普通用户`
  String get generalGood {
    return Intl.message(
      '进阶佳丽/普通用户',
      name: 'generalGood',
      desc: '',
      args: [],
    );
  }

  /// `进阶佳丽/经纪人`
  String get generalBroker {
    return Intl.message(
      '进阶佳丽/经纪人',
      name: 'generalBroker',
      desc: '',
      args: [],
    );
  }

  /// `审核驳回`
  String get reviewReject {
    return Intl.message(
      '审核驳回',
      name: 'reviewReject',
      desc: '',
      args: [],
    );
  }

  /// `审核过程中发现提交的信息存在缺失、矛盾或错误。例如，在填写申请表时漏填关键信息，或在..`
  String get auditErrorPrompt {
    return Intl.message(
      '审核过程中发现提交的信息存在缺失、矛盾或错误。例如，在填写申请表时漏填关键信息，或在..',
      name: 'auditErrorPrompt',
      desc: '',
      args: [],
    );
  }

  /// `综合评分`
  String get synthesize {
    return Intl.message(
      '综合评分',
      name: 'synthesize',
      desc: '',
      args: [],
    );
  }

  /// `累计约会次数`
  String get cumulativeNumber {
    return Intl.message(
      '累计约会次数',
      name: 'cumulativeNumber',
      desc: '',
      args: [],
    );
  }

  /// `我的标签`
  String get myTag {
    return Intl.message(
      '我的标签',
      name: 'myTag',
      desc: '',
      args: [],
    );
  }

  /// `客户评价`
  String get clientEvaluation {
    return Intl.message(
      '客户评价',
      name: 'clientEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `您还不是VIP，暂时无法使用该功能。\n点击下方按钮可立即充值`
  String get seenVip {
    return Intl.message(
      '您还不是VIP，暂时无法使用该功能。\n点击下方按钮可立即充值',
      name: 'seenVip',
      desc: '',
      args: [],
    );
  }

  /// `立即前往充值VIP`
  String get goNowToVIP {
    return Intl.message(
      '立即前往充值VIP',
      name: 'goNowToVIP',
      desc: '',
      args: [],
    );
  }

  /// `跟Ta联系`
  String get getTouchWith {
    return Intl.message(
      '跟Ta联系',
      name: 'getTouchWith',
      desc: '',
      args: [],
    );
  }

  /// `昨天`
  String get yesterday {
    return Intl.message(
      '昨天',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `请输入服务费`
  String get pleaseEnterService {
    return Intl.message(
      '请输入服务费',
      name: 'pleaseEnterService',
      desc: '',
      args: [],
    );
  }

  /// `请输入您要修改的服务费`
  String get chargeService {
    return Intl.message(
      '请输入您要修改的服务费',
      name: 'chargeService',
      desc: '',
      args: [],
    );
  }

  /// `总评价`
  String get overallMerit {
    return Intl.message(
      '总评价',
      name: 'overallMerit',
      desc: '',
      args: [],
    );
  }

  /// `分`
  String get minute {
    return Intl.message(
      '分',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `来自用户`
  String get fromUser {
    return Intl.message(
      '来自用户',
      name: 'fromUser',
      desc: '',
      args: [],
    );
  }

  /// `团队列表`
  String get teamList {
    return Intl.message(
      '团队列表',
      name: 'teamList',
      desc: '',
      args: [],
    );
  }

  /// `解约`
  String get cancelContract {
    return Intl.message(
      '解约',
      name: 'cancelContract',
      desc: '',
      args: [],
    );
  }

  /// `联系佳丽`
  String get contactBeauty {
    return Intl.message(
      '联系佳丽',
      name: 'contactBeauty',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get signOut {
    return Intl.message(
      '退出登录',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `普通用户`
  String get normalUser {
    return Intl.message(
      '普通用户',
      name: 'normalUser',
      desc: '',
      args: [],
    );
  }

  /// `佳丽`
  String get beautifulUser {
    return Intl.message(
      '佳丽',
      name: 'beautifulUser',
      desc: '',
      args: [],
    );
  }

  /// `经纪人`
  String get brokerUser {
    return Intl.message(
      '经纪人',
      name: 'brokerUser',
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
