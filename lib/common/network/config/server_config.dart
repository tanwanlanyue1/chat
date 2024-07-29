import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/local_storage.dart';

///api接口和websocket服务器配置
class ServerConfig {
  static const _kServer = 'server';
  final _preferences = LocalStorage('ServerConfigPreferences');

  ///开发服务器
  final Server devServer;

  ///线上服务器
  final Server releaseServer;

  Server? _server;

  static ServerConfig instance = ServerConfig();

  ///服务器地址配置
  ///- devServer 开发服务器
  ///- releaseServer 线上服务器
  ServerConfig({Server? devServer, Server? releaseServer})
      : devServer = devServer ??
            Server(
              api: Uri.parse(AppConfig.urlDevServer),
              ws: Uri.parse(''),
            ),
        releaseServer = releaseServer ??
            Server(
              api: Uri.parse(AppConfig.urlProdServer),
              ws: Uri.parse(''),
            );

  ///设置使用的服务器
  Future<bool> setServer(Server value) {
    _server = value;
    return _preferences.setJson(_kServer, value.toJson());
  }

  ///获取当前配置的服务器
  Future<Server> getServer() async {
    if(AppInfo.isRelease){
      return getDefaultServer();
    }
    _server ??= (await _preferences.getJson(_kServer))?.let(Server.fromJson);
    return _server ?? devServer;
  }

  ///获取默认服务器
  Server getDefaultServer() => AppInfo.isRelease ? releaseServer : devServer;

  ///获取所有可用的服务器列表
  List<Server> getAllServer() => [
        devServer,
        releaseServer
      ];
}

///服务器
class Server {

  ///API接口地址
  final Uri api;

  ///websocket地址
  final Uri ws;

  const Server({required this.api, required this.ws});

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      api: Uri.parse(json['api']),
      ws: Uri.parse(json['ws']),
    );
  }

  Map<String, dynamic> toJson() => {
        'api': api.toString(),
        'ws': ws.toString(),
      };

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Server &&
            (identical(other.api, api) || other.api == api) &&
            (identical(other.ws, ws) || other.ws == ws));
  }

  @override
  int get hashCode => Object.hash(runtimeType, api, ws);
}
