import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../../../common/app_color.dart';
import '../../../../../common/app_text_style.dart';
import '../../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../../common/network/api/model/user/user_model.dart';
import '../../../../../common/routes/app_pages.dart';
import '../../../../../common/service/service.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../widgets/app_image.dart';
import '../../../../../widgets/occupation_widget.dart';
import '../../../../../widgets/user_avatar.dart';
import '../../../../../widgets/user_style.dart';
import '../../../../chat/utils/chat_manager.dart';
import '../../../widgets/review_dialog.dart';

class BottomReview extends StatelessWidget {
  BottomReview({Key? key, required this.user, required this.item});

  final bool user;
  PlazaListModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _header(),
    );
  }

  ///头部
  Widget _header() {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(width: 8.rpx),
          Expanded(
            child: Container(
              height: 46.rpx,
              padding: EdgeInsets.only(top: 2.rpx, bottom: 2.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: (item.nameplate != null &&
                                  item.nameplate!.isNotEmpty)
                              ? 130.rpx
                              : 170.rpx,
                        ),
                        child: Text(
                          item.nickname ?? '',
                          style: AppTextStyle.fs14b
                              .copyWith(color: AppColor.black20, height: 1.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                                      UserGender.valueForIndex(item.gender ?? 0)
                                                  .index ==
                                              1
                                          ? AppColor.primaryBlue
                                          : AppColor.textPurple,
                                  height: 1.0),
                            ),
                          ],
                        ),
                      ),
                      OccupationWidget(
                          occupation: UserOccupation.valueForIndex(
                              item.occupation ?? 0)),
                      Visibility(
                        visible: item.nameplate != null &&
                            item.nameplate!.isNotEmpty,
                        child: CachedNetworkImage(
                            imageUrl: item.nameplate ?? '', height: 12.rpx),
                      )
                    ],
                  ),
                  Container(
                      height: 20.rpx,
                      margin: EdgeInsets.only(
                        right: 8.rpx,
                      ),
                      child: UserStyle(
                        styleList: item.styleList,
                      )),
                ],
              ),
            ),
          ),
          Visibility(
            visible: SS.login.userId != item.uid! && !user,
            child: GestureDetector(
              onTap: () {
                ChatManager().startChat(userId: item.uid!);
              },
              child: AppImage.asset(
                "assets/images/plaza/plaza_hi.png",
                width: 40.rpx,
                height: 28.rpx,
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          GestureDetector(
              onTap: () {
                ReviewDialog.show(
                    pid: item.postId ?? 0,
                    callBack: (val) {
                      if (val != null && val.isNotEmpty) {}
                    });
              },
              child: Container(
                  height: 36.rpx,
                  decoration: BoxDecoration(
                    color: AppColor.white8,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  padding: EdgeInsets.only(left: 16.rpx),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 3.rpx),
                        child: AppImage.asset(
                          "assets/images/plaza/write.png",
                          width: 20.rpx,
                          height: 20.rpx,
                        ),
                      ),
                      Text(
                        S.current.writeYourComments,
                        style:
                            AppTextStyle.fs14.copyWith(color: AppColor.gray9),
                      ),
                    ],
                  ))),
          Row(
            children: [
              AppImage.asset(
                (item.isLike ?? false)
                    ? "assets/images/plaza/attention.png"
                    : "assets/images/plaza/attention_no.png",
                width: 16.rpx,
                height: 16.rpx,
              ),
              SizedBox(width: 2.rpx),
              Text('${item.likeNum ?? 0}'),

            ],
          ),
          GestureDetector(
            onTap: ()async{
              var res = await Get.toNamed(AppRoutes.allCommentsPage,arguments: {"postId": item.postId, "userId": item.uid});
              if(res != null && res.isNotEmpty){
                //callBack?.call(res);
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 28.rpx,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage.asset("assets/images/plaza/comment.png",width: 14.rpx,height: 14.rpx,),
                  SizedBox(width: 4.rpx,),
                  Padding(
                    padding: EdgeInsets.only(top: 2.rpx),
                    child: Text('${(item.commentNum != null && item.commentNum != 0) ? item.commentNum : S.current.comment}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    ]);
  }
}
