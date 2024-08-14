import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/middlewares/auth_middleware.dart';
import 'package:guanjia/common/routes/middlewares/route_welcome.dart';
import 'package:guanjia/common/routes/pages/login_pages.dart';
import 'package:guanjia/common/routes/pages/mine_pages.dart';
import 'package:guanjia/common/routes/pages/order_pages.dart';
import 'package:guanjia/common/routes/pages/wallet_pages.dart';
import 'package:guanjia/ui/ad/launch_ad/launch_ad_page.dart';
import 'package:guanjia/ui/discover/friend_date/release_invitation/release_invitation_page.dart';
import 'package:guanjia/ui/home/home_page.dart';
import 'package:guanjia/ui/plaza/all_comments/all_comments_controller.dart';
import 'package:guanjia/ui/plaza/all_comments/all_comments_page.dart';
import 'package:guanjia/ui/plaza/release_dynamic/release_dynamic_page.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_page.dart';
import 'package:guanjia/ui/welcome/welcome_page.dart';
import 'package:guanjia/widgets/web/web_page.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final routeObserver = RouteObserver<ModalRoute<void>>();
  static const initial = AppRoutes.welcome;
  // static const initial = AppRoutes.home;

  static final routes = [
    ...LoginPages.routes,
    ...MinePages.routes,
    ...WalletPages.routes,
    ...OrderPages.routes,
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.releaseDynamicPage,
      page: () => ReleaseDynamicPage(),
    ),
    GetPage(
      name: AppRoutes.userCenterPage,
      page: () => UserCenterPage(),
      binding: BindingsBuilder.put(() => UserCenterController(
        userId: Get.tryGetArgs('userId'),
      )),
    ),
    GetPage(
      name: AppRoutes.allCommentsPage,
      page: () => AllCommentsPage(),
      binding: BindingsBuilder.put(() => AllCommentsController(
        postId: Get.tryGetArgs('postId'),
        userId: Get.tryGetArgs('userId'),
      )),
    ),
    GetPage(
      name: AppRoutes.webPage,
      page: () => WebPage(
        url: Get.getArgs('url', ''),
        title: Get.getArgs('title', ''),
      ),
    ),
    GetPage(
      name: AppRoutes.launchAd,
      page: () => LaunchAdPage(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      middlewares: [
        RouteWelcomeMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.releaseInvitation,
      page: () => ReleaseInvitationPage(),
    ),
  ].addMiddleware(AuthMiddleware());
}
