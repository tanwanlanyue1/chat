import 'package:dio/dio.dart';
import 'proxy_config.dart';

///代理配置
class ProxyConfigImpl implements ProxyConfigInterface{
  @override
  void apply(Dio client) {}

  @override
  Future<bool> getEnabled() async{
    return false;
  }

  @override
  Future<String> getServer() {
    throw UnimplementedError();
  }

  @override
  Future<bool> setEnabled(bool isEnabled){
    throw UnimplementedError();
  }

  @override
  Future<bool> setServer(String host) {
    throw UnimplementedError();
  }

}