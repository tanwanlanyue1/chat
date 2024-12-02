import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
          height: 219.rpx,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx), // 设置圆角半径
          ),
          child: AppImage.network(
            (item.isVideo ?? false)
                ? item.videoCover ?? ''
                : getFirstImage(item.images) ?? '',
            borderRadius: BorderRadius.circular(8.rpx),
          ),
        ),
        Visibility(
            visible: isLook,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rpx),
                child: Container(
                  height: 219.rpx,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.rpx),
                    color: const Color(0x00000000).withOpacity(0.6),
                  ),
                  alignment: Alignment.center,
                  child: Text('刚刚看过',
                      style: AppTextStyle.fs14.copyWith(color: Colors.white)),
                ))),
        Positioned(
            bottom: 8.rpx,
            right: 8.rpx,
            child: GestureDetector(
                onTap: () {
                  getCommentLike();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      AppImage.asset(
                        (item.isLike ?? false)
                            ? "assets/images/plaza/attention.png"
                            : "assets/images/plaza/private_notlike.png",
                        width: 16.rpx,
                        height: 16.rpx,
                      ),
                      SizedBox(width: 4.rpx),
                      Text(
                        '${item.likeNum ?? 0}',
                        style: AppTextStyle.fs12.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ))),
        Positioned(
            top: 8.rpx,
            right: 8.rpx,
            child: (item.isVideo ?? false)
                ? AppImage.asset(
                    "assets/images/plaza/private_photo_vedio_ic.png",
                    width: 20.rpx,
                    height: 20.rpx,
                  )
                : Stack(
                    children: [
                      AppImage.asset(
                        "assets/images/plaza/private_photo_count_bg.png",
                        width: 20.rpx,
                        height: 20.rpx,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3.rpx, top: 7.rpx),
                        child: Visibility(
                            visible: getImageCount(item.images) > 0,
                            child: RichText(
                                text: TextSpan(
                              style: TextStyle(
                                  fontSize: 7.rpx,
                                  color: const Color(0xff666666),
                                  height: 1),
                              children: <TextSpan>[
                                const TextSpan(text: '+'),
                                TextSpan(
                                    text: "${getImageCount(item.images) - 1}",
                                    style: TextStyle(fontSize: 9.rpx)),
                              ],
                            ))),
                      )
                    ],
                  )),
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
        if (((item.price ?? 0) > 0))
          Positioned(
              top: 35.rpx,
              width: 167.rpx,
              child: Container(
                width: 167.rpx,
                child: buildCover(),
              ))
      ]),
    );
  }

  Widget buildCover() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.userCenterPage,
                arguments: {"userId": item.uid});
          },
          child: buildUserAvatar(),
        ),
        SizedBox(height: 8.rpx),
        Text(
          item.nickname ?? '',
          style:
              AppTextStyle.fs14b.copyWith(color: AppColor.black20, height: 1.0),
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
                  color: UserGender.valueForIndex(item.gender ?? 0)
                      .iconColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.rpx)),
              margin: EdgeInsets.only(left: 4.rpx, right: 4.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage.asset(
                      UserGender.valueForIndex(item.gender ?? 0).icon,
                      width: 8.rpx,
                      height: 8.rpx),
                  SizedBox(
                    width: 2.rpx,
                  ),
                  Text(
                    "${item.age ?? ''}",
                    style: AppTextStyle.fs10.copyWith(
                        color:
                            UserGender.valueForIndex(item.gender ?? 0).index ==
                                    1
                                ? AppColor.primaryBlue
                                : AppColor.textPurple,
                        height: 1.0),
                  ),
                ],
              ),
            ),
            OccupationWidget(
                occupation: UserOccupation.valueForIndex(item.occupation ?? 0)),
            Visibility(
              visible: item.nameplate != null && item.nameplate!.isNotEmpty,
              child: CachedNetworkImage(
                  imageUrl: item.nameplate ?? '', height: 12.rpx),
            )
          ],
        )
      ],
    );
  }

  Widget buildUserAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppImage.svga(
          'assets/images/plaza/头像.svga',
          width: 70.rpx,
          height: 70.rpx,
        ),
        Container(
          width: 51.5.rpx,
          height: 51.5.rpx,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xffC644FC), // 描边颜色
              width: 1.5.rpx, // 描边宽度
            ),
          ),
        ),
        UserAvatar.circle(
          item.avatar ?? "",
          size: 50.rpx,
        ),
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
