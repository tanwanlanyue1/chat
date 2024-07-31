import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/network.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_info.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/widgets/setting_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

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
        title: Text(S.current.setting),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(top: 12.rpx),
                children: [
                  SettingItem(
                    bottom: 1.rpx,
                    title: "震动提醒",
                    right: SizedBox(
                      width: 46.rpx,
                      child: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: state.shake.value,
                          activeColor: AppColor.primary,
                          trackColor: AppColor.gray9,
                          onChanged: (value){
                            state.shake.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SettingItem(
                    title: "铃声提醒",
                    right: SizedBox(
                      width: 46.rpx,
                      child: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: state.bell.value,
                          activeColor: AppColor.primary,
                          trackColor: AppColor.gray9,
                          onChanged: (value){
                            state.bell.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SettingItem(
                    bottom: 1.rpx,
                    title: "修改登录密码",
                    callBack: () {
                      Get.toNamed(AppRoutes.updatePasswordPage);
                    },
                  ),
                  SettingItem(
                    bottom: 1.rpx,
                    title: "设置支付密码",
                    callBack: () {
                      Get.toNamed(AppRoutes.paymentPasswordPage);
                    },
                  ),
                  SettingItem(
                    title: "修改支付密码",
                    callBack: () {
                      Get.toNamed(AppRoutes.updatePasswordPage,arguments: {"login":false});
                    },
                  ),
                  SettingItem(
                    title: "语言切换",
                    bottom: 1.rpx,
                    borderRadius: BorderRadius.circular(8.rpx),
                    callBack: () {
                      Get.toNamed(AppRoutes.permissions);
                    },
                  ),
                  SettingItem(
                    title: "清空缓存",
                    bottom: 1.rpx,
                    trailing: Text(
                      controller.cacheSize.value,
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.rpx),
                      bottomRight: Radius.circular(8.rpx),
                    ),
                    callBack: () => controller.onTapClearCache(),
                  ),
                  SettingItem(
                    title: "检测新版本",
                    trailing: Text(
                      '1.0.1',
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.rpx),
                      bottomRight: Radius.circular(8.rpx),
                    ),
                    // callBack: () => controller.onTapClearCache(),
                  ),

                  SettingItem(
                    title: "关于我们",
                    bottom: 1.rpx,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.rpx),
                      topRight: Radius.circular(8.rpx),
                    ),
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
                api: Uri.parse('http://192.168.2.18:19900'),
                ws: Uri.parse(''),
              ),
              //杨文
              Server(
                api: Uri.parse('http://192.168.2.117:19900'),
                ws: Uri.parse(''),
              ),
              //安伟
              Server(
                api: Uri.parse('http://192.168.2.114:19900'),
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
