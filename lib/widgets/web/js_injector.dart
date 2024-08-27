
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/network/config/server_config.dart';
import 'package:guanjia/common/network/httpclient/interceptor/header_interceptor.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/image_gallery_utils.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

///JS注入
class JsInjector{
  final WebViewController controller;
  final VoidCallback? onBeadsIncrement;

  JsInjector(this.controller,{this.onBeadsIncrement}){
    controller.addJavaScriptChannel(
      '__js_bridge__',
      onMessageReceived: _onMessageReceived,
    );
  }

  Future<void> inject() async{
    final js = await rootBundle.loadString('assets/js/js_bridge.js');
    controller.runJavaScript(js);
  }

  void _onMessageReceived(JavaScriptMessage message) async {
    AppLogger.d('_onMessageReceived: ${message.message}');
    try{
      final json = jsonDecode(message.message);
      if(json is! Map){
        AppLogger.w('_onMessageReceived type error: ${json.runtimeType}, message: ${message.message}');
        return;
      }
      final method= json.getString('method');
      final uuid= json.getInt('uuid');
      switch(method){
        case 'getRequestHeaders':
          _getRequestHeaders(method, uuid);
          break;
        case 'getAccessToken':
          _getAccessToken(method, uuid);
          break;
        case 'getUserInfo':
          _getUserInfo(method, uuid);
          break;
        case 'showToast':
          _showToast(method, uuid, json);
          break;
        case 'showLoading':
          _showLoading(method, uuid, json);
          break;
        case 'hideLoading':
          _hideLoading(method, uuid);
          break;
        case 'goto':
          _goto(method, uuid, json);
          break;
        case 'goBack':
          _goBack(method, uuid);
          break;
        case 'copyText':
          _copyText(method, uuid, json);
          break;
        case 'saveGallery':
          _saveGallery(method, uuid, json);
          break;
        case 'onBeadsIncrement':
          _onBeadsIncrement(method, uuid, json);
          break;
        case 'getBinding':
          _getBinding(method, uuid);
          break;
        case 'clearCache':
          _clearCache(method, uuid);
          break;
      }
    }catch(ex){
      AppLogger.w(ex);
    }
  }


  ///android和iOS的请求头
  void _getRequestHeaders(String method, int uuid) async{
    final headers = {
      ...(await const HeaderInterceptor().getAppHeaders()),
      ...(await Global.getAuthorizedHeaders()),
      'baseUrl': (await ServerConfig.instance.getServer()).api.toString(),
    };
    await _invokeJavaScript(method, jsonEncode(headers), uuid);
  }

  ///获取登录token
  void _getAccessToken(String method, int uuid) async{
    final userId = SS.login.info?.uid;
    final token = SS.login.token;
    String? args;
    if(userId != null && token != null){
      args = jsonEncode({
        'token': token,
        'userId': userId,
      });
    }
    await _invokeJavaScript(method, args, uuid);
  }

  ///获取登录token
  void _getUserInfo(String method, int uuid) async{
    final userInfo = SS.login.info;
    String? args;
    if(userInfo != null){
      args = jsonEncode(userInfo.toJson());
    }
    await _invokeJavaScript(method, args, uuid);
  }

  ///获取绑定信息
  void _getBinding(String method, int uuid) async{
    final bindingInfo = SS.login.info;
    String? args;
    if(bindingInfo != null){
      args = jsonEncode(bindingInfo.toJson());
    }
    await _invokeJavaScript(method, args, uuid);
  }


  ///注销后清除缓存
  void _clearCache(String method, int uuid) async{
    SS.login.signOut(userAction: false).then((value) => {
      Get.navigateToHomeOrLogin()
    });
    await _invokeJavaScript(method, null, uuid);
  }

  ///showToast
  void _showToast(String method, int uuid, Map data) async{
    final msg = data.getString('message');
    if(msg.isNotEmpty){
      Loading.showToast(msg);
    }
    await _invokeJavaScript(method, null, uuid);
  }

  ///showLoading
  void _showLoading(String method, int uuid, Map data) async{
    final msg = data.getString('message');
    Loading.show(message: msg.isNotEmpty ? msg : null);
    await _invokeJavaScript(method, null, uuid);
  }

  ///hideLoading
  void _hideLoading(String method, int uuid) async{
    Loading.dismiss();
    await _invokeJavaScript(method, null, uuid);
  }

  ///跳转页面
  void _goto(String method, int uuid, Map data) async{
    final path = data.getString('path');
    if(path.isNotEmpty){
      Get.toNamed(path, arguments: data);
    }
    await _invokeJavaScript(method, null, uuid);
  }

  ///关闭页面
  void _goBack(String method, int uuid) async{
    Get.back();
    await _invokeJavaScript(method, null, uuid);
  }

  ///复制文字
  void _copyText(String method, int uuid, Map data) async{
    final message = data.getString('message');
    if(message.isNotEmpty){
      message.copy();
    }
    await _invokeJavaScript(method, null, uuid);
  }

  ///保存图片到相册
  void _saveGallery(String method, int uuid, Map data) async{
    final url = data.getString('url');
    var result = false;
    if(url.startsWith('http')){
      result = await ImageGalleryUtils.saveNetworkImage(url);
    }
    await _invokeJavaScript(method, jsonEncode({
      'result': result,
    }), uuid);
  }

  ///佛珠滚了一圈
  void _onBeadsIncrement(String method, int uuid, Map data) async{
    onBeadsIncrement?.call();
    await _invokeJavaScript(method, null, uuid);
  }

  Future<void> _invokeJavaScript(String method, String? args, int uuid){
    AppLogger.d('_invokeJavaScript: method=$method,  args=$args,  uuid=$uuid');
    return controller.runJavaScript('JSBridge.${method}Return($args, $uuid)');
  }

}
