import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/ui/login/login_phone_binding/login_phone_binding_controller.dart';
import '../../../ui/login/login_page.dart';
import '../../../ui/login/login_phone_binding/login_phone_binding_page.dart';
import '../app_pages.dart';

class LoginPages {
  static final routes = [
    GetPage(
      name: AppRoutes.loginPage,
      page: () {
        var args = Get.tryGetArgs("type");
        return (args != null && args is int)
            ? LoginPage(type: args)
            : LoginPage();
      },
    ),
    GetPage(
      name: AppRoutes.loginPhoneBindingPage,
      page: () => LoginPhoneBindingPage(),
      binding: BindingsBuilder.put(() => LoginPhoneBindingController(
            code: Get.getArgs<String>('code', ''),
            userIdentifier: Get.getArgs<String>('userIdentifier', ''),
            identityToken: Get.getArgs<String>('identityToken', ''),
            loginType: Get.getArgs<int>('loginType', 0),
          )),
    ),
  ];
}
