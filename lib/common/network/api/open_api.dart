import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/utils/app_logger.dart';

import 'model/open/google_places_model.dart';

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
        "googleToken": recaptchaToken,
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
        "googleToken": recaptchaToken,
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
      '/openapi/googleTokenVerify',
      params: {
        'token': recaptchaToken,
      },
    );
  }

  ///上传推送id
  ///- pushId 推送ID
  static Future<ApiResponse<void>> updatePushId(String pushId) async {
    return HttpClient.get(
      '/api/user/updatePushId',
      params: {
        'pushId': pushId,
      },
    );
  }

  ///通过经纬度获取地理位置
  ///- 文档：https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding?hl=zh-cn#reverse-requests
  ///- latitude 纬度
  ///- longitude 经度
  static Future<ApiResponse<void>> geocode({
    required double latitude,
    required double longitude,
  }) async {
    try{
      final response = await HttpClient.request(
        'https://maps.googleapis.com/maps/api/geocode/json',
        params: {
          'latlng': '$latitude,$longitude',
          'key': AppConfig.googleMapsApiKey,
        },
        options: Options(
          method: 'GET',
          responseType: ResponseType.plain,
        )
      );
      print('geocode: ${response.data}');
      return ApiResponse.success(response.data);
    }catch(ex){
      return ApiResponse.error(AppException(-1, '请求失败'));
    }
  }

  ///搜索附近地点
  ///- 文档：https://developers.google.com/maps/documentation/places/web-service/search-nearby?hl=zh-cn
  ///- latitude 纬度
  ///- longitude 经度
  ///- radius 半径（米）
  ///- keyword 搜索关键字
  ///- language 语言编码 https://developers.google.com/maps/faq?hl=zh-cn#languagesupport
  ///- rankby 排序方式 prominence：该选项根据结果的重要性对结果进行排序。排名将偏向于设置半径内的突出位置，而不是附近匹配但不太突出的位置。一个地方的突出程度可能受到谷歌指数排名、全球受欢迎程度和其他因素的影响。当指定突出度时，需要radius参数； distance：此选项根据与指定位置的距离按升序对搜索结果进行偏置。当指定距离时，需要输入关键字、名称或类型中的一个或多个，不允许输入半径。
  static Future<ApiResponse<List<PlaceModel>>> searchNearPlaces({
    required double latitude,
    required double longitude,
    int? radius,
    String? keyword,
    String? language,
    String rankby = 'distance',
  }) async {
    try{
      final response = await HttpClient.request(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        params: {
          'location': '$latitude,$longitude',
          if(rankby !='distance') 'radius': radius, //rankby=distance时，不可传入radius，否则参数错误
          'key': AppConfig.googleMapsApiKey,
          'rankby': rankby,
          if(keyword != null) 'keyword': keyword,
          if(language != null) 'language': language,
        },
        options: Options(
          method: 'GET',
          responseType: ResponseType.plain,
        )
      );
      final data = response.data?.toString();
      if(data != null){
        final model = GooglePlacesModel.fromJson(jsonDecode(data));
        if(model.isSuccess){
          return ApiResponse.success(model.results);
        }
      }
      return ApiResponse.error(AppException(-1, '获取数据失败'));
    }catch(ex){
      AppLogger.w(ex);
      return ApiResponse.error(AppException(-1, '请求失败'));
    }
  }
}
