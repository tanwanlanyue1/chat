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
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(12.rpx),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 2.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _buildBody(),
          _imageViews(context),
          _createBottom(),
          _comment(),
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
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item?.uid});
                  },
                  child: Text(
                    "${item?.nickname}",
                    style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
                  ),
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
          GestureDetector(
            child: AppImage.asset(
              "assets/images/discover/more.png",
              width: 20.rpx,
              height: 20.rpx,
            ),
            onTap: (){
              Get.bottomSheet(
                CommonBottomSheet(
                  titles: ["不看Ta的", "删除(个人发布者)", "取消关注","发起聊天"],
                  onTap: (index) async {},
                ),
              );
            },
          ),
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
        child: Text(
          item?.content ?? '超级可爱的小魔仙，对各种新鲜事物非常感兴趣。超级可爱的小魔仙，可爱的小魔仙，可爱的小魔仙，可爱...',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray8),maxLines: 3,overflow: TextOverflow.ellipsis,
        )
      ),
      onTap: (){
        Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
      },
    );
  }

  ///图片
  Widget _imageViews(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 12.rpx,top: 10.rpx),
        alignment: Alignment.centerLeft,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: user ? 2 : 5,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: user ? 2 : 3,
              childAspectRatio: 1,
              mainAxisSpacing: 8.rpx
          ),
          itemBuilder: (BuildContext context, int index) {
            return  Padding(
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
                // child: AppImage.network("${jsonDecode(item?.images)[index]}",
                child: AppImage.asset("assets/images/plaza/back_image.png",
                  fit: BoxFit.cover,
                  // borderRadius: BorderRadius.circular(4.rpx),
                ),
              ),
            );
          },
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
        Visibility(
          visible: user,
          child: Text("${CommonUtils.getCommonTime(time: item?.createTime,hideYears: true) }",style: TextStyle(color: Color(0xff999999),fontSize: 12.rpx),),
        ),
        Visibility(
          visible: user,
          child: const Spacer(),
        ),
        GestureDetector(
          onTap: (){
            getCommentCollect();
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            padding: EdgeInsets.symmetric(horizontal: 6.rpx,vertical: 4.rpx),
            margin: EdgeInsets.only(top: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset((item?.isCollect ?? false) ? "assets/images/plaza/attention.png":"assets/images/plaza/attention_no.png",width: 16.rpx,height: 16.rpx,),
                Text(' ${item?.collectNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.toNamed(AppRoutes.plazaDetailPage,arguments: {"communityId":item?.postId,"userId":item?.uid});
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            padding: EdgeInsets.only(top: 4.rpx,left: 4.rpx,right: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset("assets/images/plaza/comment.png",width: 16.rpx,height: 16.rpx,),
                Text(' 评论',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !user,
          child: const Spacer(),
        ),
        CommonGradientButton(
          width: 80.rpx,
          height: 30.rpx,
          text: "发起聊天",
        ),
      ],
    );
  }


  ///评论
  Widget _comment(){
    return Container(
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.only(top: 16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...List.generate(2, (index) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("隔壁老王：",style: AppTextStyle.fs12b.copyWith(color: AppColor.gray5),),
                  Expanded(child: Text("小姐姐，真美呀！晚上约一下？",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),)),
                ],
              ),
              Visibility(
                visible: index == 0,
                child: Container(
                  height: 1.rpx,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 16.rpx),
                ),
              )
            ],
          )),
          SizedBox(height: 12.rpx,),
          Text("查看全部>",style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
        ],
      ),
    );
  }
}


