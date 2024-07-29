import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'js_injector.dart';
import 'web_state.dart';

class WebController extends GetxController {
  final WebState state = WebState();
  late WebViewController webViewController;
  final String url;

  WebController(this.url);

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController();
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
  }
}
