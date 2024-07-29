import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/mine/widgets/setting_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'account_data_controller.dart';

///账户资料
class AccountDataPage extends StatelessWidget {
  AccountDataPage({super.key});

  final controller = Get.put(AccountDataController());
  final state = Get.find<AccountDataController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "账户资料",
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.rpx,
          ),
        ),
      ),
      backgroundColor: const Color(0xffF6F8FE),
      body: Obx(() {
        final info = controller.loginService.info;

        final birth = info?.birth?.dateTime?.formatYMD ?? "未设置";

        return ListView(
          padding: EdgeInsets.all(12.rpx),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx)),
              height: 82.rpx,
              padding: EdgeInsets.all(12.rpx),
              margin: EdgeInsets.only(bottom: 10.rpx),
              child: InkWell(
                onTap: controller.selectCamera,
                child: Row(
                  children: [
                    Text(
                      "头像",
                      style: TextStyle(fontSize: 15.rpx),
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29.rpx),
                      child: AppImage.network(
                        info?.avatar ?? "",
                        width: 58.rpx,
                        height: 58.rpx,
                        placeholder: AppImage.asset(
                          "assets/images/mine/user_head.png",
                          width: 58.rpx,
                          height: 58.rpx,
                        ),
                      ),
                    ),
                    AppImage.asset(
                      "assets/images/mine/right.png",
                      width: 20.rpx,
                      height: 20.rpx,
                    ),
                  ],
                ),
              ),
            ),
            SettingItem(
              title: "昵称",
              bottom: 1.rpx,
              trailing: Text(
                info?.nickname ?? "请输入您的昵称",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.rpx),
                topRight: Radius.circular(8.rpx),
              ),
              callBack: () {
                Get.toNamed(AppRoutes.updateInfoPage, arguments: {"type": 0});
              },
            ),
            SettingItem(
              title: "个性签名",
              autoHeight: true,
              trailing: Text(
                info?.signature ?? "未编写个性签名",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.rpx),
                bottomRight: Radius.circular(8.rpx),
              ),
              callBack: () {
                Get.toNamed(AppRoutes.updateInfoPage, arguments: {"type": 1});
              },
            ),
            SettingItem(
              title: "性别",
              bottom: 1.rpx,
              trailing: Text(
                state.getGenderString(info?.gender),
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.rpx),
                topRight: Radius.circular(8.rpx),
              ),
              callBack: controller.selectSex,
            ),
            SettingItem(
              title: "生日（阳历）",
              bottom: 1.rpx,
              borderRadius: BorderRadius.zero,
              trailing: Text(
                birth,
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              callBack: () {
                Pickers.showDatePicker(
                  context,
                  onConfirm: (val) {
                    if (val.year == null ||
                        val.month == null ||
                        val.day == null) return;
                    controller.selectBirth(val.year!, val.month!, val.day!);
                  },
                  pickerStyle: PickerStyle(
                    title: Center(
                      child: Text(
                        "阳历",
                        style: TextStyle(
                          fontSize: 16.rpx,
                        ),
                      ),
                    ),
                    pickerTitleHeight: 65.rpx,
                    commitButton: Padding(
                      padding: EdgeInsets.only(right: 12.rpx),
                      child: Text(
                        "完成",
                        style: TextStyle(
                            fontSize: 14.rpx, color: const Color(0xff8D310F)),
                      ),
                    ),
                    cancelButton: Padding(
                      padding: EdgeInsets.only(left: 12.rpx),
                      child: AppImage.asset(
                        "assets/images/disambiguation/close.png",
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ),
                    headDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                  ),
                );
              },
            ),
            SettingItem(
              title: "生肖",
              bottom: 1.rpx,
              borderRadius: BorderRadius.zero,
              callBack: () {},
              trailing: Text(
                info?.zodiac ?? "",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              right: const SizedBox(),
            ),
            SettingItem(
              title: "星座",
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.rpx),
                bottomRight: Radius.circular(8.rpx),
              ),
              callBack: () {},
              trailing: Text(
                info?.star ?? "",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              right: const SizedBox(),
            ),
          ],
        );
      }),
    );
  }
}
