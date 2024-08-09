import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:guanjia/widgets/loading.dart';
import '../http_client.dart';

///用户未认证回调
typedef UnauthorizedCallback = void Function();

///登录认证请求头
typedef AuthenticationHeaderProvider = Future<Map<String, dynamic>> Function();

///用户认证请求头拦截器
class AuthenticationInterceptor extends Interceptor{

  ///登录认证请求头
  final AuthenticationHeaderProvider authenticationHeaderProvider;

  ///用户未认证或认证已过期回调
  final UnauthorizedCallback? onUnauthorized;

  const AuthenticationInterceptor({
    required this.authenticationHeaderProvider,
    this.onUnauthorized
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final result = authenticationHeaderProvider.call();
    options.headers.addAll(await result);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(response.statusCode == 200){
      final data = response.data;
      if(data is Map<String, dynamic>){
        final apiResponse = ApiResponse.fromJson(data);
        if([401, 4].contains(apiResponse.code)){
          onUnauthorized?.call();
        }
      }
    }
    super.onResponse(response, handler);
  }

}