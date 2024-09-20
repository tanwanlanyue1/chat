import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'mine_permissions_controller.dart';

class MinePermissionsPage extends StatelessWidget {
  MinePermissionsPage({Key? key}) : super(key: key);

  final controller = Get.put(MinePermissionsController());
  final state = Get.find<MinePermissionsController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      appBar: AppBar(
        title: Text(S.current.permissionSetting),
      ),
      body: GetBuilder<MinePermissionsController>(builder: (_) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(12.rpx),
                child: Text(
                  S.current.useProductsFunctions,
                  style: TextStyle(
                    color: const Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.rpx,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                itemCount: state.items.length,
                separatorBuilder: (_, int index) => SizedBox(height: 10.rpx),
                itemBuilder: (_, index) {
                  var item = state.items[index];
                  return Container(
                    padding: EdgeInsets.only(
                        left: 12.rpx,
                        right: 12.rpx,
                        top: 12.rpx,
                        bottom: 10.rpx),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    child: GestureDetector(
                      onTap: () => controller.onTapAppSetting(item.type),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          AppImage.asset(item.icon,
                              width: 36.rpx, height: 36.rpx),
                          SizedBox(width: 12.rpx),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          color: const Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.rpx,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.isOpen ? S.current.alreadyOpen : S.current.alreadyNot,
                                      style: TextStyle(
                                        color: const Color(0xFF888888),
                                        fontSize: 11.rpx,
                                      ),
                                    ),
                                    if (!item.isOpen)
                                      AppImage.asset(
                                          "assets/images/mine/mine_right_arrow.png",
                                          width: 14.rpx,
                                          height: 14.rpx),
                                  ],
                                ),
                                SizedBox(height: 5.rpx),
                                Text(
                                  item.detail,
                                  style: TextStyle(
                                    color: const Color(0xFF666666),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.rpx,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        );
      }),
    );
  }
}
