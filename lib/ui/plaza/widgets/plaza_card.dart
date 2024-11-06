import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/plaza_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/occupation_widget.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/user_avatar.dart';
import 'package:guanjia/widgets/user_style.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'review_dialog.dart';

///广场列表卡片
///user:用户首页
///关注:我的关注
///item: 广场项 isSelect
class PlazaCard extends StatelessWidget {
  final bool user;
  final int? plazaIndex;
  final EdgeInsets? margin;
  PlazaListModel item;
  final Function(bool like)? isLike;//点击点赞
  final Function(String? str)? callBack;//评论回复
  final Function()? more;//更多
  PlazaCard({super.key,this.user = false,this.plazaIndex = 0,required this.item,this.isLike,this.callBack,this.more,this.margin});

  ///点赞或者取消点赞
  /// type:点赞类型（1动态2评论）
  Future<void> getCommentLike() async {
    final response = await PlazaApi.getCommentLike(
        id: item.postId!,
    );
    if(response.isSuccess){
      if(response.data == 0){
        isLike?.call(true);
      }else{
        isLike?.call(false);
      }
    }else{
      response.showErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
      margin: margin ?? EdgeInsets.only(bottom: 12.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          Container(
            margin: EdgeInsets.only(left: user ? 0 : 58.rpx),
            child: Column(
              children: [
                _buildBody(),
                _imageViews(),
                _createBottom(),
              ],
            ),
          ),
          Container(
            color: const Color(0xff999999).withOpacity(0.1),
            height: 1.rpx,
            margin: EdgeInsets.only(top: 8.rpx),
          ),
        ],
      ),
    );
  }

  ///头部
  Widget _header(){
    return Visibility(
      visible: !user,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
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
              padding: EdgeInsets.only(top: 2.rpx,bottom: 2.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: (item.nameplate != null && item.nameplate!.isNotEmpty) ? 130.rpx : 170.rpx,
                        ),
                        child: Text(item.nickname ?? '',style: AppTextStyle.fs14b.copyWith(color: AppColor.black20, height: 1.0),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
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
                    ],
                  ),
                  Container(
                      height: 20.rpx,
                      margin: EdgeInsets.only(right: 8.rpx,),
                      child: UserStyle(styleList: item.styleList,)
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: SS.login.userId != item.uid! && !user,
            child: GestureDetector(
              onTap: (){
                ChatManager().startChat(userId: item.uid!);
              },
              child: AppImage.asset("assets/images/plaza/plaza_hi.png",width: 40.rpx,height: 28.rpx,),
            ),
          )
        ],
      ),
    );
  }

  ///卡片内容
  Widget _buildBody(){
    return item.content != null && item.content!.isNotEmpty ?
    Container(
        margin: EdgeInsets.only(top: user ? 0 : 6.rpx,bottom: 8.rpx),
        alignment: Alignment.centerLeft,
        child: Text(
          item.content!.fixAutoLines(),style: AppTextStyle.fs14.copyWith(color: AppColor.black3,height: 1.5),
        )
    ) :
    Container();
  }

  ///图片
  Widget _imageViews() {
    return item.images != null && jsonDecode(item.images).isNotEmpty ?
    Container(
      padding: EdgeInsets.only(bottom: 6.rpx),
      alignment: Alignment.centerLeft,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: jsonDecode(item.images).length > 3 ? 3 : jsonDecode(item.images).length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: jsonDecode(item.images).length == 2 ? 2 : 3,
          mainAxisSpacing: 5.rpx,
          crossAxisSpacing: 5.rpx,
          pattern: jsonDecode(item.images).length == 2 ?
          [
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
          ]:[
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
          ],
        ),
        itemBuilder: (_, int index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  PhotoViewGalleryPage.show(
                      Get.context!,
                      PhotoViewGalleryPage(
                        images: jsonDecode(item.images ?? ''),
                        index: index,
                        heroTag: '',
                      ));
                },
                child: AppImage.network("${jsonDecode(item.images ?? '')?[index]}",
                  memCacheHeight: Get.width/3,
                  memCacheWidth: Get.width/3,
                  fit: BoxFit.cover,
                  // placeholder: AppImage.asset("assets/images/plaza/back_image.png",
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Visibility(
                visible: index == 2,
                child: Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 35.rpx,
                    height: 18.rpx,
                    decoration: const BoxDecoration(
                        color: Color(0x99000000)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage.asset("assets/images/plaza/plaza_img.png",width: 12.rpx,height: 12.rpx,),
                        Text("+${jsonDecode(item.images).length}",style: AppTextStyle.fs12m.copyWith(color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    ):
    Container();
  }

  ///底部
  Widget _createBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${CommonUtils.getCommonTime(time: item.createTime,) }",style: TextStyle(color: const Color(0xff999999),fontSize: 12.rpx),),
        const Spacer(),
        GestureDetector(
          onTap: (){
            getCommentLike();
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            margin: EdgeInsets.only(right: 16.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset((item.isLike ?? false) ? "assets/images/plaza/attention.png":"assets/images/plaza/attention_no.png",width: 16.rpx,height: 16.rpx,),
                SizedBox(width: 4.rpx,),
                Text('${(item.likeNum != null && item.likeNum != 0) ? item.likeNum : S.current.praise}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async{
            var res = await Get.toNamed(AppRoutes.allCommentsPage,arguments: {"postId": item.postId, "userId": item.uid});
            if(res != null && res.isNotEmpty){
              callBack?.call(res);
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
        Visibility(
          visible: plazaIndex! > 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: EdgeInsets.only(left: 16.rpx),
              child: AppImage.asset(
                "assets/images/discover/more.png",
                width: 16.rpx,
                height: 16.rpx,
              ),
            ),
            onTap: () => more?.call(),
          ),
        ),
      ],
    );
  }

}


