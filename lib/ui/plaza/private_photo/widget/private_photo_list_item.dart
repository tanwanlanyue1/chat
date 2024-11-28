import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/app_text_style.dart';
import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../widgets/app_image.dart';

class PrivatePhotoListItem extends StatelessWidget {
  PrivatePhotoListItem({Key? key, this.onItemTap, required this.item})
      : super(key: key);
  final VoidCallback? onItemTap; // 定义回调函数
  final PlazaListModel item;
  RxBool isLook = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Stack(children: [
        Container(
          height: 200.rpx,
          color: Colors.black,
          child: AppImage.network((item.isVideo ?? false) ? item.videoCover??'':getFirstImage(item.images)??'' ),
        ),
        Obx(() => Visibility(
            visible: isLook.value,
            child: Container(
              height: 220.rpx,
              color: Colors.black.withOpacity(0.1),
              alignment: Alignment.center,
              child: Text('刚刚看过',
                  style: AppTextStyle.fs14.copyWith(color: Colors.white)),
            ))),
        Positioned(
          bottom: 10,
          right: 10,
          child: AppImage.asset("assets/images/plaza/attention.png"),
          height: 18.rpx,
          width: 18.rpx,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Text((item.isVideo ?? false) ? "视频" : "图片",style: AppTextStyle.fs14.copyWith(color: Colors.white)),),
        Positioned(
            top: 10,
            left: 10,
            child: Text(((item.price??0) > 0) ? "收费" : "免费",style: AppTextStyle.fs14.copyWith(color: Colors.white))),
      ]),
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
