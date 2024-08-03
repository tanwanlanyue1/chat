import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/middlewares/auth_middleware.dart';
import 'package:guanjia/common/routes/middlewares/route_welcome.dart';
import 'package:guanjia/common/routes/pages/login_pages.dart';
import 'package:guanjia/common/routes/pages/mine_pages.dart';
import 'package:guanjia/common/routes/pages/wallet_pages.dart';
import 'package:guanjia/ui/ad/launch_ad/launch_ad_page.dart';
import 'package:guanjia/ui/home/home_page.dart';
import 'package:guanjia/ui/plaza/classification_square/classification_square_page.dart';
import 'package:guanjia/ui/plaza/plaza_detail/plaza_detail_controller.dart';
import 'package:guanjia/ui/plaza/plaza_detail/plaza_detail_page.dart';
import 'package:guanjia/ui/plaza/release_dynamic/release_dynamic_page.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_page.dart';
import 'package:guanjia/ui/welcome/welcome_page.dart';
import 'package:guanjia/widgets/web/web_page.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const initial = AppRoutes.welcome;
  // static const initial = AppRoutes.home;

  static final routes = [
    ...LoginPages.routes,
    ...MinePages.routes,
    ...WalletPages.routes,
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.releaseDynamicPage,
      page: () => ReleaseDynamicPage(),
    ),
    GetPage(
      name: AppRoutes.classificationSquarePage,
      page: () => ClassificationSquarePage(
        topicItem: Get.tryGetArgs('topicItem'),
        type: Get.getArgs('type', 0),
      ),
    ),
    GetPage(
      name: AppRoutes.userCenterPage,
      page: () => UserCenterPage(
        userId: Get.getArgs('userId', null),
      ),
    ),
    GetPage(
        name: AppRoutes.plazaDetailPage,
        page: () => PlazaDetailPage(),
        binding: BindingsBuilder.put(() => PlazaDetailController(
              communityId: Get.tryGetArgs('communityId'),
              userId: Get.tryGetArgs('userId'),
            ))),
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
  ].addMiddleware(AuthMiddleware());
}
