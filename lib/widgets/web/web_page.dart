import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'web_controller.dart';

class WebPage extends StatelessWidget {
  final String url;
  final String title;
  const WebPage({super.key, required this.url, required this.title});

  static void go({required String url, String? title, Map<String, dynamic>? args}) async{
    if(!url.startsWith('http')){
      return;
    }

    //使用浏览器打开
    final openWithBrowser = args?.getBool('openWithBrowser') ?? false;
    if(openWithBrowser){
      launchUrlString(url, mode: LaunchMode.externalApplication);
      return;
    }

    Get.toNamed(AppRoutes.webPage, arguments: {
      'url': url,
      'title': title,
      if(args != null) ...args,
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WebController>(
      init: WebController(url),
      builder: (controller){
        final webViewController = controller.webViewController;
        return Scaffold(
          appBar: AppBar(title: Text(title), bottom: PreferredSize(
            preferredSize: Size(Get.width, 4),
            child: Obx((){
              if(controller.state.progressRx() >= 1.0){
                return Spacing.blank;
              }
              return LinearProgressIndicator(
                minHeight: 4,
                value: controller.state.progressRx(),
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3BB660)),
              );
            }),
          )),
          body: webViewController != null ? WebViewWidget(controller: webViewController) : null,
        );
      },
    );
  }
}
