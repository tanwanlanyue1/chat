import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/mine_setting/account_data/widgets/account_data_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import 'account_data_controller.dart';

///账户资料
class AccountDataPage extends StatelessWidget {
  AccountDataPage({super.key});

  final controller = Get.put(AccountDataController());
  final state = Get.find<AccountDataController>().state;

  @override
  Widget build(BuildContext context) {
    SizedBox padding = SizedBox(height: 16.rpx);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.personalInformation),
      ),
      body: Obx(() {
        final info = controller.loginService.info;

        final birth = info?.birth?.dateTime?.formatYMD ?? "未设置";

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(
                  top: 24.rpx,
                ),
                children: [
                  AccountDataItem(
                    onTap: controller.selectCamera,
                    title: "头像",
                    height: 100.rpx,
                    trailing: Container(
                      color: Colors.grey,
                      child: AppImage.network(
                        info?.avatar ?? "",
                        width: 76.rpx,
                        height: 76.rpx,
                        // placeholder: AppImage.asset(
                        //   "assets/images/mine/user_head.png",
                        //   width: 76.rpx,
                        //   height: 76.rpx,
                        // ),
                      ),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    onTap: () {
                      Get.toNamed(AppRoutes.updateInfoPage,
                          arguments: {"type": 0});
                    },
                    title: "昵称",
                    trailing: Text(
                      info?.nickname ?? "请输入您的昵称",
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    onTap: controller.selectSex,
                    title: "性别",
                    trailing: Text(
                      state.getGenderString(info?.gender),
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    onTap: controller.selectSex,
                    title: "年龄",
                    trailing: Text(
                      state.getGenderString(info?.gender),
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    onTap: controller.selectSex,
                    title: "我的位置",
                    trailing: Text(
                      state.getGenderString(info?.gender),
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    title: "个性签名",
                    trailing: Text(
                      info?.signature ?? "未编写个性签名",
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.updateInfoPage,
                          arguments: {"type": 1});
                    },
                  ),
                  padding,
                  AccountDataItem(
                    title: "生日（阳历）",
                    trailing: Text(
                      birth,
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                    onTap: () {
                      Pickers.showDatePicker(
                        context,
                        onConfirm: (val) {
                          if (val.year == null ||
                              val.month == null ||
                              val.day == null) return;
                          controller.selectBirth(
                              val.year!, val.month!, val.day!);
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
                                  fontSize: 14.rpx,
                                  color: const Color(0xff8D310F)),
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
                  padding,
                  AccountDataItem(
                    title: "生肖",
                    onTap: () {},
                    trailing: Text(
                      info?.zodiac ?? "",
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                  padding,
                  AccountDataItem(
                    title: "星座",
                    onTap: () {},
                    trailing: Text(
                      info?.star ?? "",
                      style: TextStyle(
                          fontSize: 14.rpx, color: const Color(0xff999999)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(
                  top: 14.rpx, bottom: 14.rpx + Get.mediaQuery.padding.bottom),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ]),
              child: CommonGradientButton(
                onTap: null,
                text: "保存",
                height: 50.rpx,
              ),
            ),
          ],
        );
      }),
    );
  }
}
