import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/extension/web_view_controller_extension.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_error_indicator.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

///人机身份验证对话框
class ReCaptchaDialog extends StatefulWidget {
  const ReCaptchaDialog._({super.key});

  ///返回token,需要OpenApi.recaptchaVerify验证
  static Future<String?> show() async {
    return Get.dialog<String>(const ReCaptchaDialog._());
  }

  @override
  State<ReCaptchaDialog> createState() => _ReCaptchaDialogState();
}

class _ReCaptchaDialogState extends State<ReCaptchaDialog> {
  WebViewController? webViewController;
  var isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse(
        "https://recaptcha-flutter-plugin.firebaseapp.com/?api_key=${AppConfig.recaptchaApiKey}");
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'RecaptchaFlutterChannel',
        onMessageReceived: (JavaScriptMessage receiver) {
          var token = receiver.message;
          AppLogger.d('_token: $token');
          if (token.contains("verify")) {
            token = token.substring(7);
          }
          Get.back(result: token);
        },
      )
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (val) {
        injectCss();
        Loading.show();
      }, onPageFinished: (val) {
        injectCss();
        Loading.dismiss();
        setState(() {
          isLoading = false;
        });
      }, onHttpError: (error) {
        if (uri.toString() == error.request?.uri.toString()) {
          Loading.dismiss();
          setState(() {
            isLoading = false;
            errorMsg = '加载失败';
          });
        }
      }))
      ..loadRequest(uri);
  }

  void injectCss() async {
    const js = '''
      if(document.body){
        document.body.style.setProperty('padding', 0);
        document.body.style.setProperty('margin', 0);
        document.body.style.setProperty('display', 'flex');
        document.body.style.setProperty('align-items', 'center');
        document.body.style.setProperty('justify-content', 'center');
        document.body.style.setProperty('width', '100vw');
        document.body.style.setProperty('height', '100vh');
      }
    ''';
    webViewController?.runJavaScript(js);
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    if (errorMsg?.isNotEmpty == true) {
      body = buildError();
    } else if (!isLoading) {
      body = WebViewWidget(controller: webViewController!);
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: FEdgeInsets(horizontal: 24.rpx),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            color: Colors.white,
          ),
          child: FirstPageErrorIndicator(
            title: '加载验证码失败',
            onTryAgain: () {
              setState(() {
                isLoading = true;
                errorMsg = null;
                webViewController?.reload();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    webViewController?.dispose();
    webViewController = null;
    super.dispose();
  }
}
