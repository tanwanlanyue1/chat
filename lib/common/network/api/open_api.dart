import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';

enum OpenApiLoginType {
  password,
  verifyCode,
}

/// 开放接口API
class OpenApi {
  const OpenApi._();

  /// 用户登录接口
  ///- phone: 用户手机号
  ///- loginType：用户登录类型(1:密码登录,2:验证码登录,3:微信登录,4:一键登录,5:注册账号,6苹果登录)
  ///- password：用户密码
  ///- verifyCode：验证码
  ///- code：第三方登录code
  ///- appleId：苹果登录用户唯一标识
  ///- identityToken：苹果登录授权token
  static Future<ApiResponse<LoginRes>> login({
    String? phone,
    required int loginType,
    String? password,
    String? verifyCode,
    String? code,
    String? appleId,
    String? identityToken,
  }) async {
    return HttpClient.post(
      '/openapi/login',
      data: {
        "phone": phone,
        "loginType": loginType,
        "password": password,
        "verifyCode": verifyCode,
        "code": code,
        "appleId": appleId,
        "identityToken": identityToken,
      },
      dataConverter: (json) {
        return LoginRes.fromJson(json);
      },
    );
  }

  /// 忘记密码或者修改密码
  /// phone: 用户手机号
  /// verifyCode：验证码
  /// password：用户密码
  /// confirmPassword：确认密码
  static Future<ApiResponse> forgotOrResetPassword({
    required String phone,
    required String verifyCode,
    required String password,
    required String confirmPassword,
  }) {
    return HttpClient.post(
      '/openapi/forgetPassword',
      data: {
        "phone": phone,
        "verifyCode": verifyCode,
        "password": password,
        "confirmPassword": confirmPassword,
      },
    );
  }

  /// 发送手机验证码
  /// account: 用户手机号
  static Future<ApiResponse> sms({
    required String account,
  }) {
    return HttpClient.get(
      '/openapi/sendVerifyCodeKey',
      params: {
        "account": account,
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
  /// 轮播：1我的 2广场弹窗：1占卜主页 2取名主页 3星座主页 4运势主页 5解梦 6心愿阁 7广场 8禅房主页 9思亲河主页 10供灯祈福主页 11请符法坛主页广播：1占卜 2取名 3星座 4运势 5解梦
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
}
