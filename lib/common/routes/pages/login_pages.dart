import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/ui/login/forgot/forgot_page.dart';
import 'package:guanjia/ui/login/question/question_page.dart';
import 'package:guanjia/ui/login/register/register_page.dart';
import '../../../ui/login/login_page.dart';
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
      name: AppRoutes.loginPage,
      page: () {
        var args = Get.tryGetArgs("type");
        return (args != null && args is int)
            ? LoginPage(type: args)
            : LoginPage();
      },
    ),
    GetPage(
      name: AppRoutes.loginRegisterPage,
      page: () {
        return RegisterPage();
      },
    ),
    GetPage(
      name: AppRoutes.loginForgotPage,
      page: () {
        var args = Get.tryGetArgs("isNext");
        return (args != null && args is bool)
            ? ForgotPage(isNext: args)
            : ForgotPage();
      },
    ),
    GetPage(
      name: AppRoutes.loginQuestionPage,
      page: () {
        var args = Get.tryGetArgs("page");
        return (args != null && args is int)
            ? QuestionPage(page: args)
            : QuestionPage(page: 0);
      },
    ),
  ];
}
