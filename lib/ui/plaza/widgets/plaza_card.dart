import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/plaza_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

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

  String? labelString(){
    switch(item.type){
      case 0:
        return '个人';
      case 1:
        return '佳丽';
      case 2:
        return '经纪人';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.rpx),
      color: Colors.white,
      margin: margin ?? EdgeInsets.only(bottom: 4.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          if(plazaIndex == 1)...[
            _backImage(),
            _buildBody(),
          ],
          if(!(plazaIndex == 1))...[
            _buildBody(),
            _imageViews(),
          ],
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
              Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
            },
            child: AppImage.network(
              item.avatar ?? "",
              width: 40.rpx,
              height: 40.rpx,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.rpx),
          Expanded(
            child: SizedBox(
              height: 42.rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
                    },
                    child: Text(
                      "${item.nickname}",
                      style: AppTextStyle.fs16b.copyWith(color: AppColor.black20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: item.gender != 0,
                        child: Visibility(
                          visible: item.gender == 2,
                          replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                        ),
                      ),
                      SizedBox(width: 8.rpx),
                      Text('${item.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.black22),),
                      Container(
                        width: 4.rpx,
                        height: 4.rpx,
                        margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                        decoration: const BoxDecoration(
                          color: AppColor.black92,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("${labelString()}",style: AppTextStyle.fs12m.copyWith(color: AppColor.black22),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: plazaIndex! > 0,
            child: GestureDetector(
              child: AppImage.asset(
                "assets/images/discover/more.png",
                width: 20.rpx,
                height: 20.rpx,
              ),
              onTap: () => more?.call(),
            ),
          ),
        ],
      ),
    );
  }

  ///卡片内容
  Widget _buildBody(){
    return item.content != null && item.content!.isNotEmpty ?
    Container(
        margin: EdgeInsets.only(top: user ? 0 : 10.rpx,bottom: 4.rpx),
        alignment: Alignment.centerLeft,
        child: Text(
          item.content!,style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),maxLines: 6,overflow: TextOverflow.ellipsis,
        )
    ) :
    Container();
  }

  ///关注轮播图
  Widget _backImage(){
    return item.images != null && jsonDecode(item.images).isNotEmpty?
    Container(
      height: 250.rpx,
      margin: EdgeInsets.only(top: 12.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      clipBehavior: Clip.antiAlias,
      child: Swiper(
        autoplay: jsonDecode(item.images).length > 1 ? true :false,
        loop: true,
        index: 2,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            foregroundDecoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0x00000000),
                  Color(0x4D000000),
                ],
                begin: Alignment(0.0, 0.6),
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.rpx),
                bottomRight: Radius.circular(8.rpx),
              ),
            ),
            child: AppImage.network(
              jsonDecode(item.images)?[index],
              width: Get.width,
              height: 300.rpx,
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: jsonDecode(item.images).length,
        pagination: jsonDecode(item.images).length > 1 ?
        SwiperPagination(
            alignment:  Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: const Color(0x80FFFFFF),
              size: 8.rpx,
              activeSize:8.rpx,
              space: 8.rpx,
              activeColor: Colors.white,
            )
        ):null,
        onTap: (index) {
          PhotoViewGalleryPage.show(
              Get.context!,
              PhotoViewGalleryPage(
                images: jsonDecode(item.images ?? ''),
                index: index,
                heroTag: '',
              ));
        },
      ),
    ) :
    Container();
  }

  ///图片
  Widget _imageViews() {
    return item.images != null ?
    Container(
      padding: EdgeInsets.only(bottom: 12.rpx,top: 10.rpx),
      alignment: Alignment.centerLeft,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: jsonDecode(item.images).length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: user ? 2 : 3,
            childAspectRatio: 1,
            mainAxisSpacing: 8.rpx,
            mainAxisExtent: 109.rpx,
            crossAxisSpacing: 8.rpx
        ),
        itemBuilder: (_, int index) {
          return Padding(
            padding: EdgeInsets.only(left: 0.rpx),
            child: GestureDetector(
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
                  borderRadius: BorderRadius.circular(8.rpx),
                  placeholder:  AppImage.asset("assets/images/plaza/back_image.png",
                    fit: BoxFit.cover,
                  ),
                )
            ),
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
        Visibility(
          visible: user,
          child: Text("${CommonUtils.getCommonTime(time: item.createTime,hideYears: true) }",style: TextStyle(color: Color(0xff999999),fontSize: 12.rpx),),
        ),
        Visibility(
          visible: user,
          child: const Spacer(),
        ),
        GestureDetector(
          onTap: (){
            getCommentLike();
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            margin: EdgeInsets.only(right: 24.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset((item.isLike ?? false) ? "assets/images/plaza/attention.png":"assets/images/plaza/attention_no.png",width: 16.rpx,height: 16.rpx,),
                SizedBox(width: 4.rpx,),
                Text('${(item.likeNum != null && item.likeNum != 0) ? item.likeNum : '赞'}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            ReviewDialog.show(
                pid: item.postId!,
                callBack: callBack,
            );
          },
          child: Container(
            color: Colors.transparent,
            height: 28.rpx,
            padding: EdgeInsets.only(right: 4.rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset("assets/images/plaza/comment.png",width: 14.rpx,height: 14.rpx,),
                SizedBox(width: 4.rpx,),
                Padding(
                  padding: EdgeInsets.only(top: 2.rpx),
                  child: Text('${(item.commentNum != null && item.commentNum != 0) ? item.commentNum : '评论'}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx)),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !user,
          child: const Spacer(),
        ),
        Visibility(
          visible: SS.login.userId != item.uid! && !user,
          child: Padding(
            padding: EdgeInsets.only(left: 6.rpx),
            child: CommonGradientButton(
              width: 80.rpx,
              height: 30.rpx,
              text: "发起聊天",
              onTap: (){
                ChatManager().startChat(userId: item.uid!);
              },
              textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  ///评论
  Widget _comment(){
    return item.commentList != null && item.commentList!.isNotEmpty?
    Container(
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.only(top: 16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(item.commentList!.length > 2 ? 2 : item.commentList!.length, (index) {
            CommentListModel commentList = item.commentList![index];
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "${commentList.nickname}：",
                      style: AppTextStyle.fs12b.copyWith(color: AppColor.black20),
                      children: [
                        TextSpan(
                            text: '${commentList.content}',
                            style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30)
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: index == 0 && (item.commentList?.length ?? 0) > 1,
                  child: Container(
                    height: 1.rpx,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 16.rpx),
                  ),
                )
              ],
            );
          }),
          Visibility(
            visible: item.commentList!.length > 1,
            child: GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.allCommentsPage,arguments: {"postId": item.postId, "userId": item.uid});
              },
              child: Container(
                margin: EdgeInsets.only(top: 12.rpx),
                child: Text("查看全部评论>",style: AppTextStyle.fs12m.copyWith(color: AppColor.gradientBegin),),
              ),
            ),
          ),
        ],
      ),
    ):
    Container();
  }
}


