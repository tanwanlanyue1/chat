import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_localization.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/image_cache_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/web/web_page.dart';

import 'mine_setting_state.dart';

class MineSettingController extends GetxController {
  final MineSettingState state = MineSettingState();

  final version = "".obs;

  final cacheSize = "".obs;

  void onTapClearCache() {
    ImageCacheUtils.clearAllCacheImage();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
  }

  //选择语言
  Future<void> selectLanguage() async {
    final locales = AppLocalization.instance.supportedLocales;
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [S.current.chinese, S.current.english],
        onTap: (index) async {
          AppLocalization.instance.updateLocale(locales[index]);
        },
      ),
    );
  }

  @override
  void onInit() async {
    version.value = await AppInfo.getVersion();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
    super.onInit();
  }

  //修改登录密码-未绑定手机号/邮箱需要先绑定
  void updatePassword(){
    if(SS.login.userBind){
      Get.toNamed(AppRoutes.updatePasswordPage);
    }else{
      Get.toNamed(AppRoutes.bindingPage);
    }
  }

  //设置支付密码-未绑定手机号/邮箱需要先绑定 payPwd
  void paymentPasswordPage(){
    if(! (SS.login.info?.payPwd ?? false)){
      Get.toNamed(AppRoutes.paymentPasswordPage);
      return;
    }
    if(SS.login.userBind){
      if(SS.login.info?.payPwd ?? false){
        Get.toNamed(AppRoutes.updatePasswordPage,arguments: {"login":false});
      }else{
        Get.toNamed(AppRoutes.paymentPasswordPage);
      }
    }else{
      Get.toNamed(AppRoutes.bindingPage);
    }
  }

  //注销账号
  void removeAccount(){
    if(SS.login.userBind){
      WebPage.go(
        url: AppConfig.urlAccountCancellation,
        title: S.current.removeAccount,
      );
    }else{
      Get.toNamed(AppRoutes.bindingPage);
    }
  }
}
