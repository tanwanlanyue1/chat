import 'dart:convert';
import 'dart:ui';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_blur_view.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_user_view.dart';

import '../../../../common/app_color.dart';
import '../../../../common/app_text_style.dart';
import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../common/network/api/model/user/user_model.dart';
import '../../../../common/network/api/plaza_api.dart';
import '../../../../common/routes/app_pages.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/app_image.dart';
import '../../../../widgets/edge_insets.dart';
import '../../../../widgets/occupation_widget.dart';
import '../../../../widgets/user_avatar.dart';
import '../../../../widgets/user_style.dart';

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

        /// 已看过遮罩
        Visibility(
            visible: isLook,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rpx),
                child: Container(
                  height: 219.rpx,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.rpx),
                    color: const Color(0xff000000).withOpacity(0.6),
                  ),
                  alignment: Alignment.center,
                  child: Text(S.current.hasSeen,
                      style: AppTextStyle.fs14.copyWith(color: Colors.white)),
                ))),

        /// 图片数量
        buildImgCount(),

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

        ///是否付费 查看用户信息
        if (((item.price ?? 0) > 0))
          Positioned(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.userCenterPage,
                      arguments: {"userId": item.uid});
                },
                child: PrivateUserView(item: item, isPayDialog: false,),
              ),
              SizedBox(height: 8.rpx),
              ///用户信息
              PrivateBlurView( child: buildCover(),),
            ],
          )),

        ///点赞
        Positioned(bottom: 5.rpx, right: 8.rpx, child: buildLike()),
      ]),
    );
  }

  Widget buildCover() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((item.age ?? 0) > 0)
          Row(
            children: [
              Container(
                height: 12.rpx,
                padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14.rpx)),
                margin: EdgeInsets.only(left: 8.rpx, right: 8.rpx, top: 8.rpx),
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
                          color: UserGender.valueForIndex(item.gender ?? 0)
                                      .index ==
                                  1
                              ? AppColor.primaryBlue
                              : AppColor.textPurple,
                          height: 1.0),
                    ),
                  ],
                ),
              ),
              getOccupation(UserOccupation.valueForIndex(item.occupation ?? 0)),
              Visibility(
                visible: item.nameplate != null && item.nameplate!.isNotEmpty,
                child:Container(
                    margin: EdgeInsets.only(top: 8.rpx,left: 4.rpx),
                    child: CachedNetworkImage(
                    imageUrl: item.nameplate ?? '', height: 12.rpx),)

              )
            ],
          ),
        SizedBox(
          height: 4.rpx,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.rpx),
          child: Wrap(
              runSpacing: 4.rpx,
              children: item.styleList?.map((labelModel) {
                    return getStyle(labelModel);
                  }).toList() ??
                  []),
        ),
        SizedBox(height: 6.rpx),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.rpx),
            child: Text(
              item.content ?? '',
              style: AppTextStyle.fs10.copyWith(
                  color: Colors.white, height: 15.6 / 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
        Spacer(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.rpx, vertical: 8),
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



  Widget buildImgCount() {
    return Positioned(
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
              ));
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

  Widget buildLike() {
    return GestureDetector(
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
        ));
  }

  Widget getStyle(LabelModel styleList) {
    final double skewX = 0.15;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.rpx, vertical: 2.rpx)
          .copyWith(right: 6.rpx),
      transform: Matrix4.skewX(-skewX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.rpx),
        color: Colors.white.withOpacity(0.6),
      ),
      margin: EdgeInsets.only(right: 4.rpx),
      child: Transform(
        transform: Matrix4.skewX(skewX),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage.network(
              styleList.icon,
              width: 16.rpx,
              height: 16.rpx,
            ),
            Padding(
              padding: FEdgeInsets(left: 1.rpx),
              child: Text(
                styleList.tag,
                style: AppTextStyle.fs10m.copyWith(
                    color: AppColor.black20, height: 1, fontSize: 11.rpx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getOccupation(UserOccupation occupation) {
    Color color;
    String icon;
    String text;
    switch (occupation) {
      case UserOccupation.unknown:
        return const SizedBox.shrink();
      case UserOccupation.employees:
        color = AppColor.primaryBlue;
        icon = 'assets/images/plaza/workplace.png';
        text = S.current.workplace;
        break;
      case UserOccupation.student:
        color = AppColor.green1D;
        icon = 'assets/images/plaza/student.png';
        text = S.current.student;
        break;
    }
    const skewX = 0.15;
    return Container(
      padding: FEdgeInsets(
        right: 4.rpx,
      ),
      height: 12.rpx,
      margin: EdgeInsets.only(top: 8.rpx),
      transform: Matrix4.skewX(-skewX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.rpx),
        color: Colors.white.withOpacity(0.6),
      ),
      child: Transform(
        transform: Matrix4.skewX(skewX),
        child: Row(
          children: [
            AppImage.asset(icon, width: 12.rpx),
            Padding(
              padding: FEdgeInsets(left: 1.rpx),
              child: Text(
                text,
                style: AppTextStyle.fs8.copyWith(color: color, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
