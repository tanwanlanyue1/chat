import 'package:flutter/material.dart';
import 'proxy_config.dart';

///代理配置对话框
class ProxySettingDialog extends StatefulWidget {
  const ProxySettingDialog._({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(context: context, builder: (_){
      return const ProxySettingDialog._();
    });
  }

  @override
  State<ProxySettingDialog> createState() => _State();
}

class _State extends State<ProxySettingDialog> {
  final textController = TextEditingController();
  var serverHost = '';
  var isEnabled = false;

  @override
  void initState(){
    super.initState();
    textController.addListener(() {
      serverHost = textController.text;
    });
    init();
  }

  void init() async{
    serverHost = await ProxyConfig.instance.getServer();
    isEnabled = await ProxyConfig.instance.getEnabled();
    textController.text = serverHost;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('代理设置'),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () async{
            await ProxyConfig.instance.setEnabled(isEnabled);
            await ProxyConfig.instance.setServer(serverHost);
            if(context.mounted){
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: const Text('是否启用'),
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              isEnabled = value ?? false;
            });
          },
        ),
        TextField(
          controller: textController,
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: '代理服务器地址'
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
