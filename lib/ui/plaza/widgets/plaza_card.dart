import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/plaza_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';

///广场列表卡片
///user:用户首页
///delete:用户收藏-删除
///item: 广场项 isSelect
class PlazaCard extends StatelessWidget {
  final bool user;
  final bool delete;
  PlazaListModel? item;
  final Function()? isSelectCall;//点击删除回调
  final Function(bool like)? isLike;//点击点赞
  final Function(bool collect)? isCollect;//点收藏回调
  PlazaCard({super.key,this.user = false,this.delete = false,this.item,this.isSelectCall,this.isLike,this.isCollect});

  ///点赞或者取消点赞
  /// type:点赞类型（1动态2评论）
  Future<void> getCommentLike() async {
    SS.login.requiredAuthorized(() async{
      final response = await PlazaApi.getCommentLike(
          id: item!.postId!,
          type: 1
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
    });
  }

  ///收藏或者取消收藏
  Future<void> getCommentCollect() async {
    SS.login.requiredAuthorized(() async{
      final response = await PlazaApi.getCommentCollect(
        id: item!.postId!,
      );
      if(response.isSuccess){
        if(response.data == 0){
          isCollect?.call(true);
        }else{
          isCollect?.call(false);
        }
      }else{
        response.showErrorMessage();
      }
    });
  }

  //查询详情
  Future<void> getDetail(PlazaListModel item) async {

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.rpx),
            color: AppColor.brown2,
            margin: EdgeInsets.only(bottom: 2.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                _buildBody(),
                _imageViews(context),
                _createBottom(),
              ],
            ),
          ),
        ),
        if (delete)
          GestureDetector(
            onTap: (){
              isSelectCall?.call();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.rpx),
              child: AppImage.asset(
                  // (item?['isSelect'] ?? false)
                false
                      ? "assets/images/mine/message_session_choose_select.png"
                      : "assets/images/mine/message_session_choose_normal.png",
                  width: 20.rpx,
                  height: 20.rpx),
            ),
          ),
      ],
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
              Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item?.uid});
            },
            child: AppImage.network(
              item?.avatar ?? "",
              width: 36.rpx,
              height: 36.rpx,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.rpx),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item?.uid});
                      },
                      child: Text(
                        "${item?.nickname}",
                        style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
                      ),
                    ),
                    SizedBox(width: 6.rpx),
                    Visibility(
                      visible: item?.star != null && item!.star!.isNotEmpty,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff8D310F),
                            borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                        ),
                        margin: EdgeInsets.only(right: 6.rpx),
                        padding: EdgeInsets.symmetric(vertical: 1.rpx,horizontal: 4.rpx),
                        child: Text("${item?.star}",style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1.333333),),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.gold,
                          borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2.rpx,horizontal: 4.rpx),
                      child: Text("Lv.${item?.cavLevel ?? 1}",style: TextStyle(fontSize: 10.rpx,color: Colors.white),),
                    ),
                  ],
                ),
                Text(
                  '${CommonUtils.getPostTime(time: item?.createTime,yearsFlag: true) }',
                  style: TextStyle(
                    fontSize: 12.rpx,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // GestureDetector(
          //   child: AppImage.asset(
          //     "assets/images/plaza/more.png",
          //     width: 20.rpx,
          //     height: 20.rpx,
          //   ),
          //   onTap: (){
          //     ShowBottomSheet.show();
          //   },
          // ),
        ],
      ),
    );
  }

  ///卡片内容
  Widget _buildBody(){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: user ? 0 : 10.rpx),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item?.title ?? '',style: AppTextStyle.fs16b.copyWith(color: AppColor.gray8),
            ),
            SizedBox(height: 6.rpx,),
            Text(
              item?.content ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray8),maxLines: 3,overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      ),
      onTap: (){
        getDetail(item ?? PlazaListModel.fromJson({}));
        Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
      },
    );
  }

  ///图片
  Widget _imageViews(BuildContext context) {
    return GestureDetector(
      onTap: (){
        getDetail(item ?? PlazaListModel.fromJson({}));
        Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 12.rpx,top: 10.rpx),
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(jsonDecode(item?.images).length, (index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 14.rpx),
              child: GestureDetector(
                onTap: () {
                  PhotoViewGalleryPage.show(
                      context,
                      PhotoViewGalleryPage(
                        images: jsonDecode(item?.images),
                        index: index,
                        heroTag: '',
                      ));
                },
                child: AppImage.network(
                  "${jsonDecode(item?.images)[index]}",
                  width: 100.rpx,
                  height: 80.rpx,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(4.rpx),
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  ///底部
  Widget _createBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(141, 49, 15, 0.15),
            borderRadius: BorderRadius.circular(4.rpx),
          ),
          height: 16.rpx,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8.rpx),
          padding: EdgeInsets.symmetric(horizontal: 4.rpx),
          child: Text(item?.zoneName ?? "",style: AppTextStyle.fs10b.copyWith(color: AppColor.red1),),
        ),
        Visibility(
          visible: user,
          child: Text("${CommonUtils.getCommonTime(time: item?.createTime,hideYears: true) }",style: TextStyle(color: Color(0xff999999),fontSize: 12.rpx),),
        ),
        const Spacer(),
        GestureDetector(
          onTap: (){
            getCommentCollect();
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            padding: EdgeInsets.symmetric(horizontal: 6.rpx,vertical: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset((item?.isCollect ?? false) ? "assets/images/plaza/collect.png":"assets/images/plaza/uncollect.png",width: 16.rpx,height: 16.rpx,),
                Container(
                  margin: EdgeInsets.only(top: 4.rpx),
                  child: Text(' ${item?.collectNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            getDetail(item ?? PlazaListModel.fromJson({}));
            Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            padding: EdgeInsets.only(top: 4.rpx,left: 4.rpx,right: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset("assets/images/plaza/review.png",width: 16.rpx,height: 16.rpx,),
                Text(' ${item?.commentNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            getCommentLike();
          },
          child: Container(
            height: 28.rpx,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 4.rpx),
            child: Row(
              children: [
                AppImage.asset((item?.isLike ?? false)  ? "assets/images/plaza/liking_out.png":"assets/images/plaza/give_a_like.png",width: 16.rpx,height: 16.rpx,),
                Container(
                  padding: EdgeInsets.only(top: 4.rpx),
                  child: Text(' ${item?.likeNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


