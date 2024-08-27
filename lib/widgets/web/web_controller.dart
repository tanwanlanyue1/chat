import 'package:get/get.dart';
import 'package:guanjia/common/extension/web_view_controller_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'js_injector.dart';
import 'web_state.dart';

class WebController extends GetxController {
  final WebState state = WebState();
  WebViewController? webViewController;
  final String url;

  WebController(this.url);

  @override
  void onInit() {
    super.onInit();
    final webViewController = WebViewController();
    this.webViewController = webViewController;
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.enableZoom(false);
    final jsInjector = JsInjector(webViewController);
    webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) => jsInjector.inject(),
          onProgress: (progress){
            state.progressRx.value = progress/100;
          }
      ),
    );
    webViewController.loadRequest(Uri.parse(url));
    update();
  }

  @override
  void onClose(){
    webViewController?.dispose();
    webViewController = null;
    super.onClose();
  }
}
