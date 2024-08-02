import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/ui/plaza/widgets/show_bottom_sheet.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/down_input.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'plaza_detail_controller.dart';
import 'widgets/review_dialog.dart';
import 'widgets/review_reply.dart';

///广场详情
///communityId:动态id
///userId:作者id
class PlazaDetailPage extends StatelessWidget {
  PlazaDetailPage({Key? key}) : super(key: key);

  late final controller = Get.find<PlazaDetailController>();
  late final state = Get.find<PlazaDetailController>().state;

  ///全部评论展示 List reviewData
  void allReviewShow(CommentListModel review) {
    state.review.value = review;
    Get.bottomSheet(
        isScrollControlled: true,
        Obx(() {
          CommentListModel items = state.review.value;
          return Container(
            height: Get.height-50.rpx,
            color: Colors.white,
            padding: EdgeInsets.all(12.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("回帖详情  (${items.subComment?.length ?? 1})",style: TextStyle(fontSize: 16.rpx,fontWeight: FontWeight.bold),),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.rpx),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: AppImage.network(
                          items.avatar ?? '',
                          width: 32.rpx,
                          height: 32.rpx,
                          shape: BoxShape.circle,
                        ),
                        onTap: (){
                          Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":items.uid});
                        },
                      ),
                      SizedBox(width: 8.rpx,),
                      Expanded(
                        child: ReviewReply(
                          item: items,
                          user: true,
                          reply: true,
                          callBack: ({CommentListModel? subComment}){
                            controller.getCommentLike(
                              type: 2,
                              communityId: review.id,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.5.rpx,
                  margin: EdgeInsets.only(top: 8.rpx,bottom: 8.rpx),
                  color: const Color(0xffDDDDDD),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12.rpx),
                  child: Text("全部回复",style: TextStyle(fontSize: 16.rpx,fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return reviewItem(
                          items.subComment![index],
                          index
                      );
                    },
                    itemCount: items.subComment?.length,
                  ),
                ),
                bottomChat(
                    all: true
                ),
              ],
            ),
          );
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      body: Column(
        children: [
          topBar(),
          Expanded(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: buildBody(),
                  ),
                  PagedSliverList(
                    pagingController: controller.pagingController,
                      builderDelegate: DefaultPagedChildBuilderDelegate<CommentListModel>(
                          pagingController: controller.pagingController,
                          itemBuilder: (_,item,index){
                            return Container(
                              padding: EdgeInsets.all(12.rpx),
                              color: Colors.white,
                              child: reviewItem(item,index),
                            );
                          })
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: bottomChat(),
    );
  }
  ///头部
  Widget topBar() {
    return GetBuilder<PlazaDetailController>(
      id: 'userInfo',
      builder: (_){
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 12.rpx, top: Get.mediaQuery.padding.top + 12.rpx,bottom: 5.rpx),
          child: Row(
            children: [
              AppBackButton.dark(),
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":state.authorInfo.value.uid});
                },
                child: AppImage.network(
                  state.authorInfo.value.avatar ?? "",
                  width: 32.rpx,
                  height: 32.rpx,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.rpx),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":state.authorInfo.value.uid});
                      },
                      child: Text(
                        state.authorInfo.value.nickname ?? '',
                        style: TextStyle(
                            fontSize: 12.rpx,
                            color: const Color(0xff666666)
                        ),
                      ),
                    ),
                    SizedBox(height: 2.rpx,),
                    Row(
                      children: [
                        Visibility(
                          visible: state.authorInfo.value.star != null && state.authorInfo.value.star!.isNotEmpty,
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff8D310F),
                                borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                            ),
                            margin: EdgeInsets.only(right: 6.rpx),
                            padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 1.rpx),
                            child: Text("${state.authorInfo.value.star}",style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1.333333),),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEEC88A),
                              borderRadius: BorderRadius.all(Radius.circular(2.rpx))
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 2.rpx),
                          child: Text("Lv.0",style: TextStyle(fontSize: 10.rpx,color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              state.isAttention != null ?
              GestureDetector(
                child: Container(
                  width: 56.rpx,
                  height: 26.rpx,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 12.rpx),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(13.rpx)),
                    color:  (state.isAttention ?? false) ? AppColor.gray14 : Colors.transparent,
                    border: Border.all(width: 1.rpx,color: (state.isAttention ?? false) ? Colors.transparent : Color(0xff8D310F)),
                  ),
                  child: Text(state.isAttention! ? '已关注': '+关注',style: TextStyle(color: (state.isAttention ?? false) ? AppColor.gray9 : Color(0xff8D310F),fontSize: 12.rpx),),
                ),
                onTap: (){
                  controller.attention();
                },
              ):
              Container(),
              // GestureDetector(
              //   onTap: () {
              //     ShowBottomSheet.show();
              //   },
              //   child: AppImage.asset(
              //     "assets/images/plaza/more.png",
              //     width: 24.rpx,
              //     height: 24.rpx,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  ///文字内容
  Widget buildBody(){
    return GetBuilder<PlazaDetailController>(
      builder: (_){
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.articleDetail.title ?? '',style: TextStyle(fontSize: 18.rpx,fontWeight: FontWeight.bold),),
                  Text((state.articleDetail.content ?? ''),style: TextStyle(fontSize: 14.rpx),),
                  imageViews(),
                  label(),
                  Container(
                    margin: EdgeInsets.only(top: 12.rpx,bottom: 8.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: state.articleDetail.zoneName != null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(141, 49, 15, 0.15),
                              borderRadius: BorderRadius.circular(2.rpx),
                            ),
                            margin: EdgeInsets.only(right: 8.rpx),
                            padding: EdgeInsets.symmetric(horizontal: 5.rpx,vertical: 2.rpx),
                            child: Text(state.articleDetail.zoneName ?? '',style: TextStyle(color: const Color(0xff8D310F),fontSize: 10.rpx),),
                          ),
                        ),
                        Text("${CommonUtils.getPostTime(time: state.articleDetail.createTime,yearsFlag: true) }",style: TextStyle(color: const Color(0xff999999),fontSize: 12.rpx),),
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            controller.getCommentCollect();
                          },
                          child: Container(
                            height: 20.rpx,
                            color: Colors.transparent,
                            padding: EdgeInsets.only(right: 12.rpx,left: 16.rpx),
                            child: Row(
                              children: [
                                AppImage.asset((state.articleDetail.isCollect ?? false)  ? "assets/images/plaza/collect.png":"assets/images/plaza/uncollect.png",width: 16.rpx,height: 16.rpx,),
                                Container(
                                  padding: EdgeInsets.only(top: 4.rpx),
                                  child: Text(' ${state.articleDetail.collectNum ?? 0}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4.rpx),
                          child: AppImage.asset("assets/images/plaza/review.png",width: 16.rpx,height: 16.rpx,),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4.rpx),
                          child: Text(' ${state.articleDetail.commentNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                        ),
                        GestureDetector(
                          onTap: (){
                            controller.getCommentLike();
                          },
                          child: Container(
                            height: 20.rpx,
                            color: Colors.transparent,
                            padding: EdgeInsets.only(right: 6.rpx,left: 16.rpx),
                            child: Row(
                              children: [
                                AppImage.asset((state.articleDetail.isLike ?? false)  ? "assets/images/plaza/liking_out.png":"assets/images/plaza/give_a_like.png",width: 16.rpx,height: 16.rpx,),
                                Container(
                                  padding: EdgeInsets.only(top: 4.rpx),
                                  child: Text(' ${state.articleDetail.likeNum ?? 0}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.rpx),
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              color: Colors.white,
              child: Column(
                children: [
                  ObxValue((dropValuer) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '全部评论 ',
                          style: TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.rpx,
                          ),
                          children: [
                            TextSpan(
                              text: state.commentCount != null ? '(${state.commentCount})' : '',
                              style: TextStyle(
                                color: const Color(0xff999999),
                                fontSize: 16.rpx,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.rpx,
                        width: 64.rpx,
                        child: DownInput(
                          value: dropValuer.value,
                          data: state.dropData,
                          hitStr: '',
                          defaultBackgroundColor: Colors.transparent,
                          defaultTextColor: const Color(0xff666666),
                          defaultIconColor: const Color(0xff684326),
                          iconWidget: AppImage.asset(
                            "assets/images/disambiguation/down_white.png",
                            width: 12.rpx,
                            height: 12.rpx,
                            color: const Color(0xff666666),
                          ),
                          callback: (val) {
                            dropValuer.value = val['name'];
                            state.dropType = val['type'];
                            controller.getCommentList();
                          },
                        ),
                      ),
                    ],
                  ), state.dropValuer),
                  Container(
                    height: 0.5.rpx,
                    color: const Color(0xffDDDDDD),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  ///图片
  Widget imageViews() {
    return Container(
      padding: EdgeInsets.only(bottom: 12.rpx,top: 10.rpx),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: state.articleDetail.images != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(jsonDecode(state.articleDetail.images).length ?? 0, (index)=> Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 14.rpx),
            child: GestureDetector(
              onTap: () {
                PhotoViewGalleryPage.show(
                    Get.context!,
                    PhotoViewGalleryPage(
                      images: jsonDecode(state.articleDetail.images),
                      index: index,
                      heroTag: '',
                    ));
              },
              child: AppImage.network(
                "${jsonDecode(state.articleDetail.images)[index]}",
                width: 100.rpx,
                height: 80.rpx,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(4.rpx),
              ),
            ),
          ),
        ),
      ):
        Container(),
      )
    );
  }

  ///标签
  Widget label(){
    return Visibility(
      visible: state.articleDetail.topicName != null,
      child: GestureDetector(
        onTap: controller.labelTap,
        child: Container(
          color: const Color(0xffF6F6F6),
          padding: EdgeInsets.all(12.rpx),
          width: double.infinity,
          child: Text("#${state.articleDetail.topicName}#", style: TextStyle(fontSize: 12.rpx,color: const Color(0xff684326)),),
        ),
      ),
    );
  }

  ///评论项
  Widget reviewItem(CommentListModel item,int index){
    return Container(
      margin: EdgeInsets.only(bottom: 12.rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: AppImage.network(
              item.avatar ?? '',
              width: 32.rpx,
              height: 32.rpx,
              shape: BoxShape.circle,
            ),
            onTap: (){
              Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
            },
          ),
          SizedBox(width: 8.rpx,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewReply(
                  item: item,
                  user: true,
                  callBack: ({CommentListModel? subComment}){
                    controller.getCommentLike(
                        type: 2,
                        communityId: subComment != null ? subComment.id : item.id,
                        index: index,
                        sub: subComment != null
                    );
                  },
                ),
                Visibility(
                  visible: (item.subComment?.length ?? 0) > 0,
                  child: InkWell(
                    onTap: ()  {
                      state.rootId = item.id;
                      allReviewShow(item);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.gray14,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4.rpx),
                            bottomRight: Radius.circular(4.rpx),
                          ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8.rpx,bottom: 4.rpx),
                      child: Text('共${item.subComment?.length}条回复 >',
                          style: TextStyle(
                              fontSize: 14.rpx,
                              color: const Color(0xff77C1FF))),
                    ),
                  ),
                ),
                Container(
                  height: 0.5.rpx,
                  margin: EdgeInsets.only(top: 12.rpx),
                  color: const Color(0xffDDDDDD),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///底部聊天
  ///all拉起全部
  Widget bottomChat({bool all = false}){
    return GetBuilder<PlazaDetailController>(
        builder: (_){
          return Container(
            height: 60.rpx,
            color: Colors.white,
            padding: EdgeInsets.only(right: 15.rpx,left: 12.rpx),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      controller.clean(
                        all: all
                      );
                    },
                    child: Container(
                      height: 36.rpx,
                      decoration: BoxDecoration(
                        color: AppColor.gray14,
                        borderRadius: BorderRadius.circular(18.rpx),
                      ),
                      padding: EdgeInsets.only(left: 16.rpx),
                      alignment: Alignment.centerLeft,
                      child: Text("说说我的看法",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray10),),
                    ),
                  ),
                ),
                SizedBox(width: 12.rpx,),
                GestureDetector(
                  onTap: (){
                    controller.getCommentCollect();
                  },
                  child: Visibility(
                    visible: state.articleDetail.isCollect ?? false,
                    replacement: AppImage.asset("assets/images/plaza/uncollect.png",width: 16.rpx,height: 16.rpx,),
                    child: AppImage.asset("assets/images/plaza/collect.png",width: 16.rpx,height: 16.rpx,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    controller.getCommentCollect();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4.rpx,right: 10.rpx),
                    child: Text(' ${state.articleDetail.collectNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    controller.getCommentLike();
                  },
                  child: AppImage.asset((state.articleDetail.isLike ?? false) ?
                  "assets/images/plaza/liking_out.png":
                  "assets/images/plaza/give_a_like.png",
                    width: 16.rpx,height: 16.rpx,),
                ),
                GestureDetector(
                  onTap: (){
                    controller.getCommentLike();
                  },
                  child: Text(' ${state.articleDetail.likeNum ?? 0}',style: TextStyle(color: const Color(0xff666666),fontSize: 12.rpx),),
                ),
              ],
            ),
          );
        }
    );
  }
}
