import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/ad/ad_manager.dart';
import 'package:guanjia/ui/welcome/welcome_storage.dart';


/// 第一次欢迎页面
class RouteWelcomeMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route){
    if (!WelcomeStorage.isPrivacyAgree) {
      return null;
    } else {
      if(ADManager.instance.getLaunchAd() != null){
        return const RouteSettings(name: AppRoutes.launchAd);
      }
      if (SS.login.isLogin) {
        return const RouteSettings(name: AppRoutes.home);
      }
      return const RouteSettings(name: AppRoutes.loginPage);
    }
  }
}
