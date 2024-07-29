import 'package:dio/dio.dart';
import 'proxy_config_native.dart'
  if(dart.library.html) 'proxy_config_web.dart';

///代理配置
abstract class ProxyConfig extends ProxyConfigInterface{
  static final instance = ProxyConfigImpl();
  ProxyConfig._();
}

///代理配置
abstract class ProxyConfigInterface{

  ///应用代理配置
  void apply(Dio client);

  ///设置代理服务器地址
  Future<bool> setServer(String host);

  ///获取代理服务器地址
  Future<String> getServer();

  ///设置启用状态
  Future<bool> setEnabled(bool isEnabled);

  ///是否启用
  Future<bool> getEnabled();
}