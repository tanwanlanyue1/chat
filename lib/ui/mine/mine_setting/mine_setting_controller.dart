import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_localization.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/common/utils/image_cache_utils.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';

import 'mine_setting_state.dart';

class MineSettingController extends GetxController {
  final MineSettingState state = MineSettingState();
  final _preferences = LocalStorage('MineSetting');

  //震动
  static const keyVibration = 'vibrationReminder';
  //铃声
  static const keyBell = 'bellReminder';

  final version = "".obs;

  final cacheSize = "".obs;

  void onTapClearCache() {
    ImageCacheUtils.clearAllCacheImage();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
  }

  @override
  Future<bool> setEnabled() async{
    return _preferences.setBool(keyVibration, state.shake.value);
  }

  @override
  Future<bool> setBell() async{
    return _preferences.setBool(keyBell, state.bell.value);
  }

  ///是否启用
  void getEnabled() async{
    state.shake.value = (await _preferences.getBool(keyVibration)) ?? false;
    state.bell.value = (await _preferences.getBool(keyBell)) ?? false;
  }

  //选择语言
  Future<void> selectLanguage() async {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [S.current.chinese, S.current.english],
        onTap: (index) async {
          AppLocalization.instance.updateLocale(Locale.fromSubtags(languageCode: state.languageCodeList[index]));
        },
      ),
    );
  }

  @override
  void onInit() async {
    version.value = await AppInfo.getVersion();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
    getEnabled();
    if((state.loginService.info?.phone?.isNotEmpty ?? false) || (state.loginService.info?.email?.isNotEmpty ?? false)){
      state.userBind = true;
    }
    super.onInit();
  }

  //修改登录密码-未绑定手机号/邮箱需要先绑定
  void updatePassword(){
    if(state.userBind){
      Get.toNamed(AppRoutes.updatePasswordPage);
    }else{
      Get.toNamed(AppRoutes.bindingPage);
    }
  }

  //设置支付密码-未绑定手机号/邮箱需要先绑定 payPwd
  void paymentPasswordPage(){
    if(state.userBind){
      if(state.loginService.info?.payPwd ?? false){
        Get.toNamed(AppRoutes.updatePasswordPage,arguments: {"login":false});
      }else{
        Get.toNamed(AppRoutes.paymentPasswordPage);
      }
    }else{
      Get.toNamed(AppRoutes.bindingPage);
    }
  }
}
