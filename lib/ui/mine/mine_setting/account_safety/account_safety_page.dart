import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/widgets/setting_item.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'account_safety_controller.dart';

///设置-账号安全
class AccountSafetyPage extends StatelessWidget {
  AccountSafetyPage({Key? key}) : super(key: key);

  final controller = Get.put(AccountSafetyController());
  final state = Get.find<AccountSafetyController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("账号安全"),
      ),
      backgroundColor: const Color(0xffF6F8FE),
      body: Padding(
        padding: EdgeInsets.all(12.rpx),
        child: ListView(
          children: [
            SettingItem(
              title: "账号ID",
              bottom: 1.rpx,
              trailing: Text(
                SS.login.info?.chatNo.toString() ?? "",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.rpx),
                topRight: Radius.circular(8.rpx),
              ),
              right: GestureDetector(
                onTap: () => controller.onTapCopyAccountId(),
                child: Container(
                  margin: EdgeInsets.only(left: 8.rpx),
                  width: 36.rpx,
                  height: 20.rpx,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
                  child: Text(
                    "复制",
                    style: TextStyle(
                        fontSize: 10.rpx, color: const Color(0xff999999)),
                  ),
                ),
              ),
            ),
            Obx(() {
              final phone = controller.loginService.bindingInfo?.phone ?? "";
              final isBinding = phone.isNotEmpty;
              final detail = isBinding ? _maskPhoneNumber(phone) : "绑定";

              return SettingItem(
                title: "手机号码",
                trailing: Text(
                  detail,
                  style: TextStyle(
                      fontSize: 14.rpx, color: const Color(0xff999999)),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.rpx),
                  bottomRight: Radius.circular(8.rpx),
                ),
                right: isBinding ? const SizedBox() : null,
                callBack: isBinding ? null : controller.onTapBinding,
              );
            }),
            SettingItem(
              title: "修改登录密码",
              bottom: 10.rpx,
              trailing: Text(
                "修改",
                style:
                    TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
              callBack: controller.onTapUpdatePassword,
            ),
            Visibility(
              // visible: state.cancelAccountLink.value.isNotEmpty,
              child: SettingItem(
                title: "账户注销",
                bottom: 1.rpx,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                callBack: controller.onTapSignOut,
              ),
            ),
            // SettingItem(
            //   title: "实名认证",
            //   trailing: Text(
            //     "未认证",
            //     style:
            //         TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
            //   ),
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(8.rpx),
            //     bottomRight: Radius.circular(8.rpx),
            //   ),
            //   callBack: () {},
            // ),
            // SettingItem(
            //   title: "微信",
            //   trailing: Text(
            //     "未绑定",
            //     style:
            //         TextStyle(fontSize: 14.rpx, color: const Color(0xff999999)),
            //   ),
            //   callBack: () {},
            // ),
            // SettingItem(
            //   title: "账户注销",
            //   callBack: () {},
            // ),
          ],
        ),
      ),
    );
  }

  String _maskPhoneNumber(String phoneNumber) {
    // 正则表达式匹配手机号码中间四位
    RegExp regExp = RegExp(r'(\d{3})\d{4}(\d{4})');
    // 使用replaceAllMapped方法进行替换
    return phoneNumber.replaceAllMapped(regExp, (Match match) {
      return '${match.group(1)}****${match.group(2)}';
    });
  }
}
