import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/utils/app_logger.dart';

enum OpenApiLoginType {
  password,
  verifyCode,
}

/// 开放接口API
class OpenApi {
  const OpenApi._();

  /// 用户登录接口
  ///- loginType：用户登录类型(1:密码登录,2:验证码登录,3:微信登录,4:一键登录,5:注册账号,6苹果登录)
  ///- account: 用户账号
  ///- phone: 用户手机号
  ///- password：用户密码
  ///- verifyCode：验证码
  ///- code：第三方登录code
  ///- appleId：苹果登录用户唯一标识
  ///- identityToken：苹果登录授权token
  ///- email：邮箱
  ///- recaptchaToken：人机校验token
  static Future<ApiResponse<LoginRes>> login({
    required int loginType,
    String? account,
    String? phone,
    String? password,
    String? verifyCode,
    String? code,
    String? appleId,
    String? identityToken,
    String? email,
    String? recaptchaToken,
  }) async {
    return HttpClient.post(
      '/openapi/login',
      data: {
        "account": account,
        "phone": phone,
        "loginType": loginType,
        "password": password,
        "verifyCode": verifyCode,
        "code": code,
        "appleId": appleId,
        "identityToken": identityToken,
        "email": email,
        "recaptchaToken": recaptchaToken,
      },
      dataConverter: (json) {
        return LoginRes.fromJson(json);
      },
    );
  }

  /// 忘记密码或者修改密码
  /// type: 验证类型 1手机号 2邮箱
  /// phone: 用户手机号
  /// email: 用户邮箱
  /// verifyCode：验证码
  /// idToken：SMS验证码idToken
  /// password：用户密码
  /// confirmPassword：确认密码
  static Future<ApiResponse> forgotOrResetPassword({
    required int type,
    String? phone,
    String? email,
    String? verifyCode,
    String? idToken,
    required String password,
    required String confirmPassword,
  }) {
    return HttpClient.post(
      '/openapi/forgetPassword',
      data: {
        "type": type,
        "phone": phone,
        "email": email,
        "verifyCode": verifyCode,
        "idToken": idToken,
        "password": password,
        "confirmPassword": confirmPassword,
      },
    );
  }

  /// 发送手机验证码
  /// type: 类型(1.手机号 2.邮箱)
  /// account: 用户手机号
  /// account: 用户手机号
  /// recaptchaToken: 人机校验token
  static Future<ApiResponse> sms({
    required int type,
    required String account,
    String? recaptchaToken,
  }) {
    return HttpClient.get(
      '/openapi/sendVerifyCodeKey',
      params: {
        "type": type,
        "account": account,
        "recaptchaToken": recaptchaToken,
      },
    );
  }

  /// 检查第三方是否绑定 手机号
  /// - type 类型(1.微信 2.苹果...)
  /// - code 第3方登录代码（微信code）
  static Future<ApiResponse<bool>> checkBindPhone({
    required int type,
    required String code,
  }) {
    return HttpClient.get('/openapi/checkBindPhone', params: {
      "type": type,
      "code": code,
    }, dataConverter: (data) {
      if (data is bool) {
        return data;
      }
      return false;
    });
  }

  /// 轮播
  /// type: 类型（1：启动页，2：轮播，3：弹窗，4：广播）
  /// 轮播：1我的 2广场弹窗：1占卜主页
  static Future<ApiResponse<List<AdvertisingStartupModel>>> startupAdvertList({
    int type = 1,
    int size = 10,
    int? position,
  }) {
    return HttpClient.get('/openapi/getAdByType', params: {
      "type": type,
      "position": position,
      "size": size,
    }, dataConverter: (data) {
      if (data is List) {
        return data.map((e) => AdvertisingStartupModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  /// 获取应用配置
  static Future<ApiResponse<AppConfigModel>> getAppConfig() {
    return HttpClient.get(
      '/openapi/getAppConfig',
      dataConverter: (data) => AppConfigModel.fromJson(data),
    );
  }

  /// 获取版本更新
  /// - version 版本名称
  /// - channel 渠道名称
  static Future<ApiResponse<AppUpdateVersionModel?>> getUpdateVersion({
    required String version,
    required String channel,
  }) {
    return HttpClient.get(
      '/openapi/getUpdateVersion',
      params: {
        'version': version,
        'channel': channel,
      },
      dataConverter: (data) {
        if (data is Map<String, dynamic>) {
          return AppUpdateVersionModel.fromJson(data);
        }
        return null;
      },
    );
  }

  /// 查询风格列表
  /// - type 风格类型 0通用 1男 2女 示例值(0) 3:征友约会
  /// - page 页码（默认1）,示例值(1)
  /// - size 每页数量（默认10）,示例值(999)
  static Future<ApiResponse<List<LabelModel>>> getStyleList({
    int type = 0,
    int page = 1,
    int size = 999,
  }) {
    return HttpClient.get(
      '/openapi/getStyleList',
      params: {
        'type': type,
        'page': page,
        'size': size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => LabelModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  /// 获取所有活动
  static Future<ApiResponse<List<AdvertisingStartupModel>>> getAdList() {
    return HttpClient.get('/openapi/getAdList', dataConverter: (data) {
      if (data is List) {
        return data.map((e) => AdvertisingStartupModel.fromJson(e)).toList();
      }
      return [];
    });
  }

  static Future<ApiResponse> sendSignallingMsg() {
    return HttpClient.get('/api/im/sendSignallingMsg');
  }

  ///recaptcha验证
  ///- token 用户人机验证返回的token
  static Future<ApiResponse<void>> recaptchaVerify(
      String recaptchaToken) async {
    return HttpClient.get(
      '/openapi/siteverify',
      params: {
        'token': recaptchaToken,
      },
    );
  }
}
