
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/web/web_page.dart';

///应用链接跳转
class AppLink{
  AppLink._();

  ///跳转WebPage或应用内页面跳转
  ///- pathOrUrl 应用内页面路径或者网页url
  ///- args 跳转参数
  static void jump(String pathOrUrl, {String? title, Map<String, dynamic>? args}){
    if(pathOrUrl.startsWith('http')){
      WebPage.go(url: pathOrUrl, title: title ?? '', args: args);
    }else{
      final page = AppPages.routes.firstWhereOrNull((element) => pathOrUrl.startsWith(element.name));
      if(page != null){

        //聊天
        if(pathOrUrl == AppRoutes.messageListPage){
          final conversationId = args?['conversationId']?.toString();
          final userId = conversationId?.let(int.tryParse);
          if(userId != null){
            ChatManager().startChat(userId: userId);
          }
          return;
        }

        Get.toNamed(pathOrUrl, arguments: args);
      }else{
        AppLogger.w('Page not found, pathOrUrl=$pathOrUrl');
      }
    }
  }

}