import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_position.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/firebase_util.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/common/utils/result.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/widgets/recaptcha_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../event/login_event.dart';
import 'service.dart';

/// 登录服务
/// 当用户完成请求完登录、绑定信息、获取等级境修币信息、用户基本信息才为成功登录，
/// 并保存用户数据到本地，全局可通过loginService全局调用。
/// 📢：isLogin 的改变是在请求完登录、获取其他各种用户信息之后才改变为登录状态
class LoginService extends GetxService {
  /// Open

  // 用户是否登录, 外部可通过obx监听改变
  bool get isLogin => _isLogin.value;

  // 当前登录用户信息, 外部可通过obx监听改变
  UserModel? get info => _info.value;

  ///监听登录状态
  StreamSubscription<bool> loginListen(void Function(bool isLogin) onData){
    return _isLogin.listen(onData);
  }

  // 提供外部修改用户信息
  void setInfo(void Function(UserModel? val) fn) {
    _info.update(fn);
  }

  // 用户 id
  int? get userId => _loginRes?.userId;

  // 用户 token
  String? get token => _loginRes?.token;

  // 用户头像
  String get avatar => info?.avatar ?? "";

  // 用户昵称
  String get nickname => info?.nickname ?? "";

  // TODO 用户是否为VIP
  bool get isVip => info?.vip ?? false;
  // bool get isVip => true;

  // 用户类型 默认用户
  UserType get userType => _info.value?.type ?? UserType.user;

  // 用户绑定信息
  bool get userBind => ((info?.phone?.isNotEmpty ?? false) ||
      (info?.email?.isNotEmpty ?? false));

  /// Private 防止外部修改

  // 当前用户登录模型
  LoginRes? _loginRes;

  // 当前用户信息
  final Rxn<UserModel> _info = Rxn<UserModel>();

  // 用户是否登录
  final _isLogin = false.obs;

  static const _kLoginData = 'loginData';
  static const _kUserData = 'userData';
  final _localStorage = LocalStorage('LoginService');

  LoginService() {
    ever(_isLogin, (isLogin) async {
      if (isLogin) {
        //连接到IM服务
        ChatManager().connect(
          userId: userId.toString(),
          nickname: info?.nickname ?? '',
          avatar: info?.avatar ?? '',
        );
        FirebaseUtil().setFcmTokenToServer();
        AppPosition.updatePosition();
      } else {
        //断开IM连接
        ChatManager().disconnect();
      }
    });
  }

  Future<LoginService> init() async {
    final loginData = await _localStorage.getJson(_kLoginData);
    final userData = await _localStorage.getJson(_kUserData);

    if (loginData == null || userData == null) {
      _isLogin.value = false;
      return this;
    }

    _loginRes = LoginRes.fromJson(loginData);
    _info.value = UserModel.fromJson(userData);

    _isLogin.value = true;

    return this;
  }

  ///需要登录授权才会执行runnable，否则跳转登录页
  void requiredAuthorized(VoidCallback runnable,
      {VoidCallback? onUnauthorized}) {
    if (isLogin) {
      runnable();
    } else {
      Loading.showToast(S.current.loginPlease);
      Get.toNamed(AppRoutes.loginPage);
      onUnauthorized?.call();
    }
  }

  ///密码登录
  ///- phone 手机号
  ///- password 密码
  Future<Result<void, String>> loginByPassword({
    required String account,
    required String password,
  }) {
    return _login(
      account: account,
      password: password,
      loginType: 1,
    );
  }

  ///验证码登录
  Future<Result<void, String>> loginByVerifyCode({
    required String phone,
    required String verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 2,
    );
  }

  ///注册登录
  Future<Result<void, String>> loginByRegister({
    required String account,
    required String password,
    String? phone,
    String? email,
  }) async{

    //人机校验
    String? recaptchaToken;
    if(SS.appConfig.configRx()?.googleVerification == true){
      recaptchaToken = await ReCaptchaDialog.show();
      if(recaptchaToken == null){
        //用户取消校验
        return const ResultFailure('');
      }
    }

    return _login(
      loginType: 5,
      account: account,
      password: password,
      phone: phone,
      email: email,
      recaptchaToken: recaptchaToken,
    );
  }

  ///本机号码一键登录
  ///- token 取号token
  Future<Result<void, String>> loginByOneKey(String token) {
    return _login(
      loginType: 4,
      code: token,
    );
  }

  ///微信登录
  ///- code 授权code
  ///- phone 手机号
  ///- verifyCode 验证码
  Future<Result<void, String>> loginByWeChat({
    required String code,
    String? phone,
    String? verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 3,
      code: code,
    );
  }

  ///Apple登录
  ///- userIdentifier 用户唯一标识
  ///- identityToken 授权token
  ///- phone 手机号
  ///- verifyCode 验证码
  Future<Result<void, String>> loginByApple({
    required String userIdentifier,
    required String identityToken,
    String? phone,
    String? verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 6,
      userIdentifier: userIdentifier,
      identityToken: identityToken,
    );
  }

  /// 用户登录
  ///- phone: 用户手机号
  ///- loginType：用户登录类型(1:密码登录,2:验证码登录,3:微信登录,4:一键登录,5:注册账号)
  ///- password：用户密码
  ///- verifyCode：验证码
  ///- code：第三方登录code
  ///- recaptchaToken：人机校验token
  /// return 错误信息
  Future<Result<void, String>> _login({
    required int loginType,
    String? account,
    String? phone,
    String? password,
    String? verifyCode,
    String? code,
    String? userIdentifier,
    String? identityToken,
    String? email,
    String? recaptchaToken,
  }) async {
    // 先请求登录接口
    final res = await OpenApi.login(
      loginType: loginType,
      account: account,
      phone: phone,
      password: password,
      verifyCode: verifyCode,
      code: code,
      appleId: userIdentifier,
      identityToken: identityToken,
      email: email,
      recaptchaToken: recaptchaToken,
    );

    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final loginRes = res.data;
    if (loginRes == null || loginRes.token.isEmpty || loginRes.userId == 0) {
      await _clearData();
      return const ResultFailure("data error");
    }

    // 保存登录信息, 后续接口需要根据请求头参数进行校验，保证先存到本地
    await _setupLoginData(loginRes: loginRes);

    // 获取用户信息并修改登录状态
    return await fetchMyInfo()
        .then((value) => value.whenAsync(success: (_) async {
              // 修改登录状态
              _isLogin.value = true;
              LoginEvent(true).emit();
              return const ResultSuccess(null);
            }, failure: (errorMessage) async {
              await _clearData();
              return ResultFailure(errorMessage);
            }));
  }

  /// 初始化用户信息
  /// gender: 性别 1：男 2：女
  /// birth：生日
  /// likeSex：喜好性别 0：其它 1：男 2：女
  /// likeStyle：喜好风格id 字符串格式 英文逗号拼接
  Future<ApiResponse> initUserInfo({
    int? gender,
    String? birth,
    int? likeSex,
    String? likeStyle,
  }) async {
    final res = await UserApi.initUserInfo(
      gender: gender,
      birth: birth,
      likeSex: likeSex,
      likeStyle: likeStyle,
    );

    return res;
  }

  /// 根据id获取用户信息
  /// userId: 用户id
  Future<Result<UserModel, String>> fetchInfo({
    required int userId,
  }) async {
    final res = await UserApi.info(uid: userId);
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final data = res.data;
    if (data == null) {
      return const ResultFailure("data error");
    }

    return ResultSuccess(data);
  }

  /// 获取当前用户信息（默认自动保存）
  /// autoSave: 是否自动保存到本地
  Future<Result<UserModel, String>> fetchMyInfo({
    bool autoSave = true,
  }) async {
    final res = await fetchInfo(userId: userId ?? 0);
    await res.whenAsync(
        success: (user) async {
          // 保存当前用户信息
          await _setupUserData(userModel: user);
          // 同步用户信息到IM服务
          ChatManager().syncUserInfo();
        },
        failure: (_) async {});
    return res;
  }

  /// 用户退出登录
  /// - userAction 是否是用户主动点击退出登录
  Future<Result<void, String>> signOut({bool userAction = true}) async {
    if (userAction) {
      final res = await UserApi.signOut();
      //不接单
      UserApi.updateState(0);
      // 清空数据
      await _clearData();
      LoginEvent(false).emit();
      if (!res.isSuccess) {
        return ResultFailure(res.errorMessage ?? "data error");
      }
    } else {
      // 清空数据
      await _clearData();
      LoginEvent(false).emit();
    }
    return const ResultSuccess(null);
  }

  /// 发送邮箱验证码
  ///- email 用户手机号
  Future<Result<void, String>> fetchEmailVerificationCode(String email) async {
    String? recaptchaToken;

    //人机校验
    if(SS.appConfig.configRx()?.googleVerification == true){
      recaptchaToken = await ReCaptchaDialog.show();
      if(recaptchaToken == null){
        //用户取消校验
        return const ResultFailure("");
      }
    }

    Loading.show();
    final res = await OpenApi.sms(type: 2, account: email, recaptchaToken: recaptchaToken);
    Loading.dismiss();
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    return const ResultSuccess(null);
  }

  /// 忘记密码或者修改密码
  /// type: 验证类型 1手机号 2邮箱
  /// phone: 用户手机号
  /// verifyCode：验证码
  /// idToken：SMS验证码idToken
  /// password：用户密码
  /// confirmPassword：确认密码
  Future<Result<void, String>> forgotOrResetPassword({
    required int type,
    String? phone,
    String? email,
    String? verifyCode,
    String? idToken,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await OpenApi.forgotOrResetPassword(
      type: type,
      phone: phone,
      email: email,
      verifyCode: verifyCode,
      idToken: idToken,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    return const ResultSuccess(null);
  }

  /// 获取用户未读消息数量
  Future<Result<void, String>> getMessagesCounts({
    required String phone,
    required int type,
  }) async {
    final res = await UserApi.getMessagesCounts();
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    return const ResultSuccess(null);
  }

  Future<void> _setupLoginData({
    required LoginRes loginRes,
  }) async {
    await _localStorage.setJson(_kLoginData, loginRes.toJson());

    _loginRes = loginRes;
  }

  Future<void> _setupUserData({
    required UserModel userModel,
  }) async {
    await _localStorage.setJson(_kUserData, userModel.toJson());

    _info.value = userModel;
  }

  Future<void> _clearData() async {
    await _localStorage.remove(_kLoginData);
    await _localStorage.remove(_kUserData);

    _loginRes = null;
    _info.value = null;

    _isLogin.value = false;
    ChatUserInfoCache().clear();
  }

  ///用户未登录，接口401回调
  void onUnauthorized() async {
    if (!isLogin || ConfirmDialog.isVisible) {
      //如果用户本来就没有登录，则不需要弹窗提示
      return;
    }
    final result = await ConfirmDialog.show(
      message: Text(S.current.loginExpired),
      okButtonText: Text(S.current.reLogin),
    );
    await signOut(userAction: false);
    Get.navigateToHomeOrLogin();
    if (result) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.toNamed(AppRoutes.loginPage),
      );
    }
  }
}
