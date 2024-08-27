
import 'package:webview_flutter/webview_flutter.dart';

extension WebViewControllerExtension on WebViewController{

  void dispose(){
    setNavigationDelegate(NavigationDelegate());
    loadRequest(Uri.parse('about:blank'));
  }

}