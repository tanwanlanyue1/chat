import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_button.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../common/network/api/api.dart';
import 'user_center_controller.dart';

///广场-用户中心
class UserCenterPage extends StatelessWidget {
  UserCenterPage({Key? key}) : super(key: key);

  final controller = Get.find<UserCenterController>();
  final state = Get.find<UserCenterController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              slivers: <Widget>[
                Obx(() => SliverAppBar(
                  pinned: true,
                  leadingWidth: 0,
                  leading: AppBackButton(brightness: state.isAppBarExpanded.value ? Brightness.dark : Brightness.light,),
                  expandedHeight: 258.rpx,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    expandedTitleScale: 1.0,
                    title: Container(
                      height: 16.rpx,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.rpx),
                          topRight: Radius.circular(24.rpx),
                        ),
                      ),
                    ),
                    collapseMode: CollapseMode.parallax,
                    background: backImage(),
                  ),
                )),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      userInfo(),
                      creativeDynamics(),
                    ],
                  ),
                ),
                PagedSliverList(
                  pagingController: controller.pagingController,
                  builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
                    pagingController: controller.pagingController,
                    itemBuilder: (_, item, index) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            PlazaCard(
                              user: true,
                              item: item,
                              margin: EdgeInsets.zero,
                              isLike: (like){
                                controller.getCommentLike(like, index);
                              },
                              callBack: (val){
                                controller.setComment(val ?? '',index);
                              },
                            ),
                            Container(
                              height: 2.rpx,
                              margin: EdgeInsets.only(left: 24.rpx,right: 16.rpx),
                              color: AppColor.scaffoldBackground,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 44.rpx+Get.mediaQuery.padding.top,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.gray40, Color(0x00000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                //Color(0x4D000000)
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: AppBackButton(brightness: state.isAppBarExpanded.value ? Brightness.dark : Brightness.light,),
                actions: [
                  Visibility(
                    visible: SS.login.userId == state.authorId,
                    child: InkWell(
                      onTap: controller.upload,
                      child: Container(
                        padding: EdgeInsets.only(right: 16.rpx,left: 12.rpx),
                        child: AppImage.asset("assets/images/plaza/uploading.png",width: 24.rpx,height: 24.rpx,color: state.isAppBarExpanded.value ? Colors.black :Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: voiceContainer(),
    );
  }

  ///背景
  Widget backImage(){
    return GetBuilder<UserCenterController>(
      id: 'userInfo',
      builder: (_){
        return SizedBox(
          height: 300.rpx,
          child: state.authorInfo.images != null ?
          Swiper(
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return AppImage.network(
                jsonDecode(state.authorInfo.images!)[index],
                width: Get.width,
                height: 300.rpx,
                fit: BoxFit.fitWidth,
              );
            },
            itemCount: jsonDecode(state.authorInfo.images!).length,
            pagination: SwiperPagination(
                alignment:  Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 30.rpx,right: 16.rpx),
                builder: DotSwiperPaginationBuilder(
                  color: const Color(0xffD1D8E6),
                  size: 8.rpx,
                  activeSize:8.rpx,
                  space: 8.rpx,
                  activeColor: AppColor.primary,
                )
            ),
            onTap: (i){
              PhotoViewGalleryPage.show(
                  Get.context!,
                  PhotoViewGalleryPage(
                    images: jsonDecode(state.authorInfo.images!),
                    index: i,
                    heroTag: '',
                  ));
            },
          ):
          GestureDetector(
            onTap: controller.upload,
            child: Container(
              height: 300.rpx,
              color: AppColor.black6,
              alignment: Alignment.center,
              child: Text(SS.login.userId == state.authorId ? "轻触上传主题背景" : '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
            ),
          ),
        );
      },
    );
  }

  ///用户信息
  Widget userInfo(){
    return GetBuilder<UserCenterController>(
      id: 'userInfo',
      builder: (_) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.rpx),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 8.rpx,left: SS.login.userId != state.authorId ? (80.rpx) : 0),
                      child: AppImage.network(
                        state.authorInfo.avatar ?? '',
                        width: 80.rpx,
                        height: 80.rpx,
                        fit: BoxFit.fitWidth,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: SS.login.userId != state.authorId,
                    child: SizedBox(
                      width: 74.rpx,
                      child: GestureDetector(
                        onTap: (){
                          controller.toggleAttention(state.authorId);
                        },
                        child: ObxValue((isAttentionRx){
                          return Row(
                            children: [
                              Visibility(
                                visible: isAttentionRx(),
                                replacement: AppImage.asset("assets/images/plaza/attention_no.png",width: 24.rpx,height: 24.rpx,),
                                child: AppImage.asset("assets/images/plaza/attention.png",width: 24.rpx,height: 24.rpx,),
                              ),
                              Container(
                                width: 50.rpx,
                                alignment: Alignment.center,
                                child: Text(isAttentionRx() ? "已关注" : '关注',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
                              )
                            ],
                          );
                        },controller.isAttentionRx),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(state.authorInfo.nickname,style: AppTextStyle.fs20b.copyWith(color: AppColor.gray5),textAlign: TextAlign.center,),
            ),
            Visibility(
              visible: state.authorInfo.type.index != 0,
              child: Text("${controller.label()}   ${state.authorInfo.position ?? ''}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(state.userBasics.length, (i) {
                return SizedBox(
                  height: 85.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${state.userBasics[i]['name']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray9),),
                      Text(controller.basicsInfo(index: i),style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                    ],
                  ),
                );
              }),
            ),
            Container(
              height: 2.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
              child: Text("个人简介",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
            ),
            Text(state.authorInfo.signature ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
            Container(
              height: 2.rpx,
              margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
              color: AppColor.scaffoldBackground,
            ),
          ],
        ),
      );
    },);
  }

  ///个人帖子
  Widget creativeDynamics(){
    return Container(
      color: AppColor.scaffoldBackground,
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.rpx),
        child: Text("个人帖子",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
      ),
    );
  }

  ///语音
  Widget voiceContainer(){
    return Visibility(
      visible: SS.login.userId != state.authorId,
      child: Container(
        height: 112.rpx,
        padding: EdgeInsets.symmetric(horizontal: 16.rpx,vertical: 12.rpx),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 12.0),
                blurRadius: 15.0,
                spreadRadius: 4.0
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('想了解我更多，跟我1对1私聊吧！',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.rpx),
              child: Row(
                children: [
                  ChatCallButton(
                    width: 60.rpx,
                    height: 50.rpx,
                    userId: state.authorId,
                    isVideoCall: false,
                    nickname: state.authorInfo.nickname,
                    jumpToChatPage: true,
                    child: Container(
                      width: 60.rpx,
                      margin: EdgeInsets.only(right: 8.rpx),
                      child: CommonGradientButton(
                        height: 50.rpx,
                        text: "实时\n语音",
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChatCallButton(
                      height: 50.rpx,
                      userId: state.authorId,
                      isVideoCall: true,
                      nickname: state.authorInfo.nickname,
                      jumpToChatPage: true,
                      child: CommonGradientButton(
                        height: 50.rpx,
                        text: "视频1V1聊天",
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}