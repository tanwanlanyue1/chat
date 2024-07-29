import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'proxy_config.dart';

///代理配置
class ProxyConfigImpl implements ProxyConfigInterface{
  static const _kServerHost = 'server_host';
  static const _kProxyEnabled = 'proxy_enabled';
  final _preferences = LocalStorage('ProxyConfigStorage');

  var _serverHost = '';
  bool? _isEnabled;

  ///应用代理配置
  @override
  void apply(Dio client) async{

    if(client.httpClientAdapter is! IOHttpClientAdapter){
      return;
    }

    if(!(await getEnabled())){
      return;
    }

    final host = await getServer();
    if(host.isEmpty){
      return;
    }

    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (httpClient){
      httpClient.badCertificateCallback = (cert, host, port) => true;
      httpClient.findProxy = (uri) => 'PROXY $host';
      return httpClient;
    };
  }

  ///设置代理服务器地址
  @override
  Future<bool> setServer(String host){
    _serverHost = host;
    return _preferences.setString(_kServerHost, host);
  }

  ///获取代理服务器地址
  @override
  Future<String> getServer() async{
    if(_serverHost.isEmpty){
      _serverHost = (await _preferences.getString(_kServerHost)) ?? '';
    }
    return _serverHost;
  }

  ///设置启用状态
  @override
  Future<bool> setEnabled(bool isEnabled) async{
    _isEnabled = isEnabled;
    return _preferences.setBool(_kProxyEnabled, isEnabled);
  }

  ///是否启用
  @override
  Future<bool> getEnabled() async{
    return _isEnabled ??= (await _preferences.getBool(_kProxyEnabled)) ?? false;
  }

}