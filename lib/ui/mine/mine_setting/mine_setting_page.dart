import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/network.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/setting_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'app_update/app_update_manager.dart';
import 'mine_setting_controller.dart';

///我的设置
class MineSettingPage extends StatelessWidget {
  MineSettingPage({Key? key}) : super(key: key);

  final controller = Get.put(MineSettingController());
  final state = Get.find<MineSettingController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.setting,style: AppTextStyle.fs18b.copyWith(color: AppColor.black20),),
      ),
      backgroundColor: AppColor.grayF7,
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 12.rpx),
                children: [
                  SettingItem(
                    bottom: 1.rpx,
                    title: S.current.vibrationReminder,
                    right: SizedBox(
                      width: 46.rpx,
                      child: Transform.scale(
                        scale: 0.8,
                        child: ObxValue((dataRx){
                          return CupertinoSwitch(
                            value: dataRx(),
                            activeColor: AppColor.primary,
                            trackColor: AppColor.gray9,
                            onChanged: dataRx.call,
                          );
                        }, SS.inAppMessage.vibrationReminderRx),
                      ),
                    ),
                  ),
                  SettingItem(
                    title: S.current.bellReminder,
                    right: SizedBox(
                      width: 46.rpx,
                      child: Transform.scale(
                        scale: 0.8,
                        child: ObxValue((dataRx){
                          return CupertinoSwitch(
                            value: dataRx(),
                            activeColor: AppColor.primary,
                            trackColor: AppColor.gray9,
                            onChanged: dataRx.call,
                          );
                        }, SS.inAppMessage.bellReminderRx),
                      ),
                    ),
                  ),
                  SettingItem(
                    bottom: 1.rpx,
                    title: S.current.changingPassword,
                    callBack: controller.updatePassword,
                    trailing: Visibility(
                      visible: !SS.login.userBind,
                      child: Text(
                        "请先绑定手机/邮箱",
                        style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                      ),
                    ),
                  ),
                  Obx(() => Visibility(
                    visible: !(SS.login.info?.payPwd ?? false),
                    replacement: SettingItem(
                      title: S.current.changingPaymentPassword,
                      callBack: controller.paymentPasswordPage,
                      trailing: Visibility(
                        visible: !SS.login.userBind,
                        child: Text(
                          "请先绑定手机/邮箱",
                          style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                        ),
                      ),
                    ),
                    child: SettingItem(
                      title: S.current.setPaymentPassword,
                      callBack: controller.paymentPasswordPage,
                    ),
                  )),
                  SettingItem(
                    title: S.current.languageSwitch,
                    bottom: 1.rpx,
                    callBack: () {
                      controller.selectLanguage();
                    },
                  ),
                  SettingItem(
                    title: S.current.clearCache,
                    bottom: 1.rpx,
                    trailing: Text(
                      controller.cacheSize.value,
                      style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                    ),
                    borderRadius: BorderRadius.zero,
                    callBack: () => controller.onTapClearCache(),
                  ),
                  SettingItem(
                    title: S.current.detectNewVersions,
                    trailing: Text(
                      '1.0.1',
                      style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),
                    ),
                    callBack: (){
                      AppUpdateManager.instance.checkAppUpdate(userAction: true);
                    },
                  ),

                  SettingItem(
                    title: S.current.aboutUs,
                    bottom: 1.rpx,
                    callBack: () {
                      Get.toNamed(AppRoutes.aboutPage);
                    },
                  ),
                  if (!AppInfo.isRelease) _buildDevServerSwitch(),
                  if (!AppInfo.isRelease) _buildProxySetting(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDevServerSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: FEdgeInsets(horizontal: 12.rpx, vertical: 4.rpx),
      child: Row(
        children: [
          Text('服务器', style: TextStyle(fontSize: 15.rpx)),
          const Spacer(),
          DevServerSwitch(
            additionServers: [
              //颜鹏
              Server(
                api: Uri.parse('http://192.168.2.18:20000'),
                ws: Uri.parse(''),
              ),
              //杨文
              // Server(
              //   api: Uri.parse('http://192.168.2.117:20000'),
              //   ws: Uri.parse(''),
              // ),
              //安伟
              Server(
                api: Uri.parse('http://192.168.2.114:20000'),
                ws: Uri.parse(''),
              ),
            ],
          ),
          AppImage.asset(
            "assets/images/mine/mine_right.png",
            width: 20.rpx,
            height: 20.rpx,
          ),
        ],
      ),
    );
  }

  Widget _buildProxySetting() {
    return GestureDetector(
      onTap: () {
        ProxySettingDialog.show(Get.context!);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 50.rpx,
        margin: FEdgeInsets(top: 8.rpx),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx),
        ),
        padding: FEdgeInsets(horizontal: 12.rpx, vertical: 4.rpx),
        child: Row(
          children: [
            Text('代理设置', style: TextStyle(fontSize: 15.rpx)),
            const Spacer(),
            AppImage.asset(
              "assets/images/mine/mine_right.png",
              width: 20.rpx,
              height: 20.rpx,
            ),
          ],
        ),
      ),
    );
  }
}
