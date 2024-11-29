import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../common/app_color.dart';
import '../../../../common/app_text_style.dart';
import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../common/network/api/model/user/user_model.dart';
import '../../../../common/network/api/plaza_api.dart';
import '../../../../common/routes/app_pages.dart';
import '../../../../widgets/app_image.dart';
import '../../../../widgets/occupation_widget.dart';
import '../../../../widgets/user_avatar.dart';

class PrivatePhotoListItem extends StatelessWidget {
  PrivatePhotoListItem(
      {Key? key,
      this.onItemTap,
      required this.item,
      required this.isLook,
      this.isLike})
      : super(key: key);
  final VoidCallback? onItemTap; // 定义回调函数
  final PlazaListModel item;
  final bool isLook;
  final Function(bool like)? isLike; //点击点赞
  ///点赞或者取消点赞
  /// type:点赞类型（1动态2评论）
  Future<void> getCommentLike() async {
    final response = await PlazaApi.getCommentLike(
      id: item.postId!,
    );
    if (response.isSuccess) {
      if (response.data == 0) {
        isLike?.call(true);
      } else {
        isLike?.call(false);
      }
    } else {
      response.showErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Stack(children: [
        Container(
          height: 200.rpx,
          color: Colors.black,
          child: AppImage.network((item.isVideo ?? false)
              ? item.videoCover ?? ''
              : getFirstImage(item.images) ?? ''),
        ),
        Visibility(
            visible: isLook,
            child: Container(
              height: 220.rpx,
              color: Colors.black.withOpacity(0.1),
              alignment: Alignment.center,
              child: Text('刚刚看过',
                  style: AppTextStyle.fs14.copyWith(color: Colors.white)),
            )),
        Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
                onTap: () {
                  getCommentLike();
                },
                child: Container(
                  width: 26.rpx,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text('${item.likeNum ?? 0}'),
                      SizedBox(height: 2.rpx),
                      AppImage.asset(
                        (item.isLike ?? false)
                            ? "assets/images/plaza/attention.png"
                            : "assets/images/plaza/attention_no.png",
                        width: 16.rpx,
                        height: 16.rpx,
                      ),
                    ],
                  ),
                ))),
        Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                Text((item.isVideo ?? false) ? "视频" : "图片",
                    style: AppTextStyle.fs14.copyWith(color: Colors.white)),
                if ((item.isVideo ?? false) == false)
                  Text(
                    "${getImageCount(item.images)}张",
                    style: AppTextStyle.fs14.copyWith(color: Colors.white),
                  ),
              ],
            )),
        Positioned(
            top: 10,
            left: 10,
            child: Text(((item.price ?? 0) > 0) ? "收费" : "免费",
                style: AppTextStyle.fs14.copyWith(color: Colors.white))),
        Align(
           alignment: Alignment.center,
            child: buildCover())
      ]),
    );
  }

  Widget buildCover(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.userCenterPage,
                arguments: {"userId": item.uid});
          },
          child: UserAvatar.circle(
            item.avatar ?? "",
            size: 46.rpx,
          ),
        ),
        SizedBox(height: 8.rpx),
        Text(
          item.nickname ?? '',
          style: AppTextStyle.fs14b
              .copyWith(color: AppColor.black20, height: 1.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Wrap(
          spacing: 8.rpx,
          runSpacing: 4.rpx,
          children: [
            Container(
              height: 12.rpx,
              padding: EdgeInsets.symmetric(horizontal: 4.rpx),
              decoration: BoxDecoration(
                  color: UserGender.valueForIndex(item.gender ?? 0).iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.rpx)
              ),
              margin: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage.asset(UserGender.valueForIndex(item.gender ?? 0).icon,width: 8.rpx,height: 8.rpx),
                  SizedBox(width: 2.rpx,),
                  Text(
                    "${item.age ?? ''}",
                    style: AppTextStyle.fs10.copyWith(color: UserGender.valueForIndex(item.gender ?? 0).index == 1 ? AppColor.primaryBlue:AppColor.textPurple,height: 1.0),
                  ),
                ],
              ),
            ),
            OccupationWidget(occupation: UserOccupation.valueForIndex(item.occupation ?? 0)),
            Visibility(
              visible: item.nameplate != null && item.nameplate!.isNotEmpty,
              child: CachedNetworkImage(imageUrl: item.nameplate ?? '',height: 12.rpx),
            )
        ],)
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

  int getImageCount(String? images) {
    if (images == null || images.isEmpty) {
      return 0;
    }
    try {
      List<dynamic> imageList = jsonDecode(images);
      if (imageList.isNotEmpty) {
        return imageList.length;
      }
    } catch (e) {
      // 处理解析错误
      print('JSON 解析错误: $e');
    }
    return 0;
  }
}
