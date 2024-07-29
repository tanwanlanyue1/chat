import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'web_controller.dart';

class WebPage extends StatelessWidget {
  final String url;
  final String title;
  const WebPage({super.key, required this.url, required this.title});

  static void go({required String url, String? title, Map<String, dynamic>? args}){
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
          body: WebViewWidget(controller: controller.webViewController),
        );
      },
    );
  }
}
