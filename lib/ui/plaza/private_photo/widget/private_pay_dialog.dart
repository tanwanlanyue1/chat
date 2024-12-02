import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/pay_dialog_blur_view.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_blur_view.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_user_view.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../../common/app_text_style.dart';
import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../common/routes/app_pages.dart';
import '../../../../common/service/service.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/app_image.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/user_avatar.dart';
import '../../../chat/widgets/chat_avatar.dart';

class PrivatePayDialog extends StatelessWidget {
  final VoidCallback? onItemTap; // 定义回调函数
  const PrivatePayDialog({
    super.key,
    required this.item,
    this.onItemTap,
  });

  final PlazaListModel item;

  ///- true 确认发起， false取消
  static Future<bool> show(PlazaListModel item, VoidCallback? onItemTap) async {
    final ret = await Get.dialog<bool>(
      PrivatePayDialog(
        item: item,
        onItemTap: onItemTap,
      ),
    );
    return ret == true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 343.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Stack(children: [
          Positioned(
            top: 10.rpx,
            right: 5.rpx,
            child: IconButton(
              onPressed: Get.back,
              icon: AppImage.asset(
                'assets/images/common/close.png',
                width: 24.rpx,
                height: 24.rpx,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24.rpx,
              ),
              Text(S.current.privatePayDialogTitle,
                  style: TextStyle(
                      fontSize: 16.rpx, color: Color(0xff020635), height: 1)),
              Container(
                  margin:
                      EdgeInsets.only(top: 16.rpx, left: 16.rpx, right: 16.rpx),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FE),
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.rpx)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height: 166.rpx,
                                width: 124.rpx,
                                child: AppImage.network((item.isVideo ?? false)
                                    ? item.videoCover ?? ''
                                    : getFirstImage(item.images) ?? ''),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.userCenterPage,
                                              arguments: {"userId": item.uid});
                                        },
                                        child: PrivateUserView(
                                          item: item,
                                          isPayDialog: true,
                                        ),
                                      ),
                                      SizedBox(height: 16.rpx),

                                      ///用户信息
                                      PayDialogBlurView(
                                        child: buildCover(),
                                      ),
                                    ],
                                  )),

                              /// 付费图标
                              Positioned(
                                  top: 8.rpx,
                                  left: 8.rpx,
                                  child: Visibility(
                                      visible: (item.price ?? 0) > 0,
                                      child: AppImage.asset(
                                        "assets/images/plaza/private_bill.png",
                                        width: 45.rpx,
                                        height: 20.rpx,
                                      ))),
                            ]),
                            Container(
                              width: 187.rpx,
                                padding: EdgeInsets.only(left: 12.rpx),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16.rpx),
                                    Text('打赏解锁后',
                                        style: AppTextStyle.fs14b.copyWith(
                                            color: Color(0xff020635),
                                            height: 1)),
                                    SizedBox(height: 16.rpx),
                                    Row(
                                      children: [
                                        AppImage.asset(
                                          "assets/images/plaza/unlock_des_ic.png",
                                          width: 12.rpx,
                                          height: 12.rpx,
                                        ),
                                        SizedBox(width: 4.rpx),
                                        Text(
                                          '可重复观看',
                                          style: AppTextStyle.fs12.copyWith(
                                              color: AppColor.black666,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.rpx),
                                    Row(
                                      children: [
                                        AppImage.asset(
                                          "assets/images/plaza/unlock_des_ic.png",
                                          width: 12.rpx,
                                          height: 12.rpx,
                                        ),
                                        SizedBox(width: 4.rpx),
                                        Text('无时间限制',
                                            style: AppTextStyle.fs12.copyWith(
                                                color: AppColor.black666,
                                                height: 1)),
                                      ],
                                    ),
                                    Container(
                                      height: 1,
                                      width: 163.rpx,
                                      margin: EdgeInsets.only(
                                          top: 20.rpx, bottom: 23.rpx),
                                      color: Color(0xff9DB21A).withOpacity(0.1),
                                    ),
                                    Row(children: [
                                      Text('解锁费用',
                                          style: AppTextStyle.fs14.copyWith(
                                              color: AppColor.black666,
                                              height: 1)),
                                      Expanded(child:Center(child:
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: '\$${item.price}',
                                            style: AppTextStyle.fs14.copyWith(
                                                color: AppColor.primaryBlue,
                                                height: 1)),
                                        if ((item.price ?? 0) >
                                            (SS.login.info?.balance ?? 0))
                                          TextSpan(
                                              text: '(金额不足)',
                                              style: AppTextStyle.fs12.copyWith(
                                                  color: AppColor.red,
                                                  height: 1))
                                      ])))),
                                    ])
                                  ],
                                )),
                          ],
                        ),
                      ))),
              Padding(padding: EdgeInsets.symmetric(vertical: 24.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                width: 300.rpx,
                text: '立即解锁',
                onTap: onItemTap,
                textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white,),
              ),
              )

            ],
          )
        ]),
      ),
    );
  }

  Widget buildCover() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.rpx,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.rpx),
            child: Text(
              item.content ?? '',
              style: AppTextStyle.fs10.copyWith(color: Colors.white, height: 1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
        Spacer(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.rpx, vertical: 8),
            child: Row(
              children: [
                UserAvatar.circle(
                  item.avatar ?? "",
                  size: 10.rpx,
                ),
                SizedBox(width: 4.rpx),
                Text(
                  item.nickname ?? '',
                  style: AppTextStyle.fs10.copyWith(
                      color: Colors.white.withOpacity(0.6), height: 1.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ))
      ],
    );
  }

  String getFirstImage(String? images) {
    if (images == null || images.isEmpty) {
      return '';
    }
    try {
      List<dynamic> imageList = jsonDecode(images);
      if (imageList.isNotEmpty) {
        return imageList[0];
      }
    } catch (e) {
      // 处理解析错误
      print('JSON 解析错误: $e');
    }
    return '';
  }
}
