import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../../common/app_text_style.dart';
import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
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
    required this.item, this.onItemTap,
  });

  final PlazaListModel item;

  ///- true 确认发起， false取消
  static Future<bool> show(PlazaListModel item , VoidCallback? onItemTap) async {
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
        child:
        Stack(children: [
          Positioned(
            top: 16.rpx,
            right: 16.rpx,
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
            SizedBox(height: 24.rpx,),
            Text(S.current.privatePayDialogTitle,
                style: TextStyle(
                  fontSize: 16.rpx,
                  color: Color(0xff020635)
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    alignment: Alignment.center,
                    children: [
                  Container(
                    margin: EdgeInsets.all(12.rpx),
                    height: 200.rpx,
                    width: 140.rpx,
                    color: Colors.black,
                    child: AppImage.network((item.isVideo ?? false)
                        ? item.videoCover ?? ''
                        : getFirstImage(item.images) ?? ''),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: AppImage.asset("assets/images/plaza/attention.png"),
                    height: 18.rpx,
                    width: 18.rpx,
                  ),
                  Positioned(
                    top: 22,
                    right: 22,
                    child: Text((item.isVideo ?? false) ? "视频" : "图片",
                        style: AppTextStyle.fs14.copyWith(color: Colors.white)),
                  ),
                  Positioned(
                      top: 22,
                      left: 22,
                      child: Text(((item.price ?? 0) > 0) ? "收费" : "免费",
                          style:
                              AppTextStyle.fs14.copyWith(color: Colors.white))),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    SizedBox(height: 10.rpx),
                    Text('解锁费用${item.price}',
                        style: TextStyle(
                          fontSize: 16.rpx,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 80.rpx),
                    Button.stadium(
                      onPressed: onItemTap,
                      height: 50.rpx,
                      width: 140.rpx,
                      child: Text('立即解锁'),
                    )
                ],)

              ],
            ),
          ],
        )]),
      ),
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
