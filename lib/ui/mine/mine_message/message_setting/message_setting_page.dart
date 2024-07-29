import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guanjia/ui/mine/widgets/setting_item.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'message_setting_controller.dart';

///消息设置页
class MessageSettingPage extends StatelessWidget {
  MessageSettingPage({Key? key}) : super(key: key);

  final controller = Get.put(MessageSettingController());
  final state = Get
      .find<MessageSettingController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        centerTitle: true,
        title: Text("消息设置", style: TextStyle(
          color: const Color(0xff333333), fontSize: 18.rpx,),),
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<MessageSettingController>(
        builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(12.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  // PermissionStatus status = await Permission.notification.status;
                  // print("status==${status}");
                  // Permission.notification.request();
                  openAppSettings();
                },
                child: Container(
                  padding: EdgeInsets.all(12.rpx),
                  margin: EdgeInsets.only(bottom: 12.rpx),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("消息推送通知 （手机通知栏）", style: TextStyle(
                              color: const Color(0xff333333), fontSize: 14.rpx),),
                          Text("已开启 >", style: TextStyle(
                              color: const Color(0xff888888), fontSize: 11.rpx),),
                        ],
                      ),
                      Text(
                        "要开启或停用消息推送可在设备设置-通知设置更改", style: TextStyle(color: const Color(0xff999999), fontSize: 12.rpx, height: 2),),
                    ],
                  ),
                ),
              ),
              Text("消息提醒",
                style: TextStyle(color: const Color(0xff999999), fontSize: 12.rpx),),
              SizedBox(height: 8.rpx,),
              SettingItem(
                title: "系统消息",
                bottom: 1.rpx,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.rpx),
                  topRight: Radius.circular(8.rpx),
                ),
                right: CupertinoSwitch(
                  value: state.messages['system'],
                  trackColor: const Color(0xffCCCCCC),
                  onChanged: (value) {
                    state.messages['system'] = value;
                    controller.update();
                  },
                ),
              ),
              SettingItem(
                title: "收到关注",
                bottom: 1.rpx,
                borderRadius: BorderRadius.zero,
                right: CupertinoSwitch(
                  value: state.messages['attention'],
                  trackColor: const Color(0xffCCCCCC),
                  onChanged: (value) {
                    state.messages['attention'] = value;
                    controller.update();
                  },
                ),
              ),
              SettingItem(
                title: "评论/回复",
                bottom: 1.rpx,
                borderRadius: BorderRadius.zero,
                right: CupertinoSwitch(
                  value: state.messages['reply'],
                  trackColor: const Color(0xffCCCCCC),
                  onChanged: (value) {
                    state.messages['reply'] = value;
                    controller.update();
                  },
                ),
              ),
              SettingItem(
                title: "被赞",
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.rpx),
                  bottomRight: Radius.circular(8.rpx),
                ),
                right: CupertinoSwitch(
                  value: state.messages['bePraised'],
                  trackColor: const Color(0xffCCCCCC),
                  onChanged: (value) {
                    state.messages['bePraised'] = value;
                    controller.update();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
