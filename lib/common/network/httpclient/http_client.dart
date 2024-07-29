import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'interceptor/authentication_interceptor.dart';
import 'proxy/proxy_config.dart';
import '../config/server_config.dart';
import 'interceptor/header_interceptor.dart';
import 'api_response.dart';
import 'app_exceptions.dart';
export 'api_response.dart';
export 'app_exceptions.dart';
export 'api_page_data.dart';
export 'proxy/proxy_config.dart' show ProxyConfig;
export 'proxy/proxy_setting_dialog.dart';

///Http请求客户端
class HttpClient {
  static final _instance = HttpClient._();
  final Dio dio;
  Locale? locale;

  HttpClient._()
      : dio = Dio(BaseOptions(
          baseUrl: ServerConfig.instance.getDefaultServer().api.toString(),
          receiveTimeout: const Duration(seconds: 60),
          connectTimeout: const Duration(seconds: 60),
        ));

  void _initialize({
    required AuthenticationHeaderProvider authenticationHeaderProvider,
    UnauthorizedCallback? onUnauthorized,
    Locale? locale,
    TBHttpClientLogger? logger,
  }) {
    this.locale = locale;
    //开发阶段使用
    if (!AppInfo.isRelease) {
      //配置的服务器地址
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        ServerConfig.instance
            .getServer()
            .then((value) => options.baseUrl = value.api.toString())
            .whenComplete(() => handler.next(options));
      }));

      //代理配置
      ProxyConfig.instance.apply(dio);
    }

    //统一请求头拦截器
    dio.interceptors.add(HeaderInterceptor(locale));
    dio.interceptors.add(AuthenticationInterceptor(
      authenticationHeaderProvider: authenticationHeaderProvider,
      onUnauthorized: onUnauthorized,
    ));

    //日志拦截器
    if (kDebugMode && logger != null) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: logger.requestHeader,
        requestBody: logger.requestBody,
        responseBody: logger.responseBody,
        responseHeader: logger.responseHeader,
        logPrint: logger.logPrint,
        maxWidth: 200,
      ));
    }
  }

  ///初始化
  ///- authenticationHeaderProvider 登录认证授权请求头
  ///- onUnauthorized 未认证或登录认证已失效 回调
  ///- local 语言
  ///- logger 日志打印
  static void initialize({
    required AuthenticationHeaderProvider authenticationHeaderProvider,
    UnauthorizedCallback? onUnauthorized,
    Locale? locale,
    TBHttpClientLogger? logger,
  }) =>
      _instance._initialize(
        authenticationHeaderProvider: authenticationHeaderProvider,
        onUnauthorized: onUnauthorized,
        locale: locale,
        logger: logger,
      );

  ///get请求
  static Future<ApiResponse<T>> get<T>(
    String url, {
    final Map<String, dynamic>? params,
    final DataConverter<T>? dataConverter,
    final Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _instance.dio.get(
        url,
        queryParameters: params,
        options: Options(headers: headers),
      );
      return ApiResponse.fromJson<T>(response.data,
          dataConverter: dataConverter);
    } catch (ex) {
      return _errorResponse<T>(ex, _instance.locale);
    }
  }

  ///post请求
  static Future<ApiResponse<T>> post<T>(
    String url, {
    final Map<String, dynamic>? params,
    final Map<String, dynamic>? data,
    final Map<String, dynamic>? headers,
    final DataConverter<T>? dataConverter,
  }) async {
    try {
      final response = await _instance.dio.post(url,
          data: data,
          queryParameters: params,
          options: Options(headers: headers));
      return ApiResponse.fromJson<T>(response.data,
          dataConverter: dataConverter);
    } catch (ex) {
      return _errorResponse<T>(ex, _instance.locale);
    }
  }

  ///post请求(update)
  static Future<ApiResponse<T>> upload<T>(
    String url, {
    final FormData? data,
    final DataConverter<T>? dataConverter,
    final void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      final response = await _instance.dio.post(
        url,
        data: data,
        onSendProgress: onSendProgress,
      );
      return ApiResponse.fromJson<T>(response.data,
          dataConverter: dataConverter);
    } catch (ex) {
      return _errorResponse<T>(ex, _instance.locale);
    }
  }

  ///文件下载
  static Future<Response> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Object? data,
    Options? options,
  }) {
    return _instance.dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
  }

  ///原始的request请求
  static Future<Response<T>> request<T>(
    String url, {
    final Map<String, dynamic>? params,
    final Map<String, dynamic>? data,
    final Options? options,
  }) async {
    return _instance.dio.request(
      url,
      data: data,
      queryParameters: params,
      options: options,
    );
  }

  ///异常转换
  static ApiResponse<T> _errorResponse<T>(dynamic exception, Locale? locale) {
    // TBLogger.e('_errorResponse=$exception');
    AppException? appException;
    final isEnglish = locale?.languageCode == 'en';
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          appException = BadRequestException(
              -1, isEnglish ? 'Connection timeout' : '连接超时');
          break;
        case DioExceptionType.badResponse:
        case DioExceptionType.connectionError:
        case DioExceptionType.badCertificate:
          appException =
              BadRequestException(-1, isEnglish ? 'Request failed' : '请求失败');
          break;
        case DioExceptionType.unknown:
        case DioExceptionType.cancel:
          break;
      }
    } else if (exception is AppException) {
      appException = exception;
    }
    return ApiResponse<T>(
      code: -1,
      exception: appException ??
          AppException(-1, isEnglish ? 'Unknown error' : '未知错误'),
    );
  }
}

///http客户端日志
class TBHttpClientLogger {
  ///是否打印请求头
  final bool requestHeader;

  ///是否打印请求体
  final bool requestBody;

  ///是否打印响应头
  final bool responseHeader;

  ///是否打印响应体
  final bool responseBody;

  final Function(Object object) logPrint;

  TBHttpClientLogger({
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = true,
    this.responseBody = false,
    required this.logPrint,
  });
}
