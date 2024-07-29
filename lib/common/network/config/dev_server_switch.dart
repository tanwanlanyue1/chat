import 'package:flutter/material.dart';
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/common/utils/app_info.dart';

///开发服务器地址切换控件
class DevServerSwitch extends StatefulWidget {
  final Color? textColor;
  final ValueChanged<Server>? onChange;
  final List<Server> additionServers;

  ///开发服务器地址切换控件
  ///- textColor 文字颜色
  ///- onChange 服务器选中
  ///- servers 添加可选服务器列表
  const DevServerSwitch({
    super.key,
    this.textColor,
    this.onChange,
    this.additionServers = const [],
  });

  @override
  State<DevServerSwitch> createState() => _DevServerSwitchState();
}

class _DevServerSwitchState extends State<DevServerSwitch> {
  Server? server;

  @override
  void initState() {
    super.initState();
    if (!AppInfo.isRelease) {
      _loadServer();
    }
  }

  void _loadServer() async {
    server = await ServerConfig.instance.getServer();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (server == null) {
      return const SizedBox.shrink();
    }
    return TextButton(
      onPressed: () => showSwitchDialog(context),
      style: TextButton.styleFrom(shape: const StadiumBorder()),
      child: Text(
        server?.api.toShortString() ?? '',
        style: TextStyle(
          color: widget.textColor,
          fontSize: 16,
        ),
      ),
    );
  }

  // 显示切换服务器地址对话框
  void showSwitchDialog(BuildContext context) {
    final servers = [
      ...widget.additionServers,
      ...ServerConfig.instance.getAllServer(),
    ];

    showModalBottomSheet(context: context, builder: (_){
      return ListView.separated(
        shrinkWrap: true,
        itemCount: servers.length,
        separatorBuilder: (_, index) => const Divider(
          height: 0,
        ),
        itemBuilder: (_, index) {
          final item = servers[index];
          return ListTile(
            title: Text(item.api.toShortString(), textAlign: TextAlign.center),
            onTap: () async {
              if (item != server) {
                await ServerConfig.instance.setServer(item);
                setState(() {
                  server = item;
                });
                widget.onChange?.call(item);
              }
              if(context.mounted){
                Navigator.pop(context);
              }
            },
          );
        },
      );
    });
  }
}

extension on Uri {
  String toShortString() {
    var text = host;
    if (hasPort) {
      text += ':$port';
    }
    return text;
  }
}
