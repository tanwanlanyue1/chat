import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
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
import 'widget/swiper_pagination.dart';

///广场-用户中心
class UserCenterPage extends StatelessWidget {
  UserCenterPage({Key? key}) : super(key: key);

  final controller = Get.find<UserCenterController>();
  final state = Get.find<UserCenterController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  systemOverlayStyle: SystemUI.lightStyle,
                  leading: AppBackButton(brightness: state.isAppBarExpanded.value ? Brightness.dark : Brightness.light,),
                  expandedHeight: 220.rpx,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        expandedTitleScale: 1.0,
                        collapseMode: CollapseMode.parallax,
                        background: backImage(),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: const Offset(0,1),
                          child: Container(
                            height: 16.rpx,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.rpx),
                                topRight: Radius.circular(24.rpx),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      userInfo(context),
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
                    noItemsFoundIndicatorBuilder:(_){
                      return const NoItemsFoundIndicator(
                        title: '暂无数据',
                        backgroundColor: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
            Obx(() => Container(
              height: 44.rpx+Get.mediaQuery.padding.top,
              decoration: BoxDecoration(
                color: state.isAppBarExpanded.value ? Colors.white : Colors.transparent
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: AppBackButton(brightness: state.isAppBarExpanded.value ? Brightness.dark : Brightness.light,),
                systemOverlayStyle: SystemUI.lightStyle,
                actions: [
                  Visibility(
                    visible: state.isAppBarExpanded.value,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 52.rpx,right: 12.rpx),
                      child: AppImage.network(
                        state.authorInfo.avatar ?? '',
                        width: 32.rpx,
                        height: 32.rpx,
                        fit: BoxFit.cover,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: state.isAppBarExpanded.value,
                    child: Center(
                      child: Text(state.authorInfo.nickname,style: AppTextStyle.fs16b.copyWith(color: AppColor.blackBlue,height: 1),),
                    ),
                  ),
                  const Spacer(),
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
            )),
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
          height: 220.rpx,
          child: state.authorInfo.images != null ?
          Swiper(
            autoplay: jsonDecode(state.authorInfo.images!).length > 1 ? true : false,
            controller: controller.swiper,
            itemBuilder: (BuildContext context, int index) {
              return AppImage.network(
                jsonDecode(state.authorInfo.images!)[index],
                width: Get.width,
                height: 220.rpx,
                fit: BoxFit.cover,
              );
            },
            itemCount: jsonDecode(state.authorInfo.images!).length,
            pagination: jsonDecode(state.authorInfo.images!).length > 1 ?
            SwiperPagination(
                alignment:  Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 30.rpx,right: 16.rpx),
                builder: UserSwiperPagination(
                  color: const Color(0xffD1D8E6),
                  size: 8.rpx,
                  activeSize:8.rpx,
                  space: 8.rpx,
                  activeColor: AppColor.primary,
                )
            ):null,
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
              height: 220.rpx,
              color: AppColor.black6,
              alignment: Alignment.center,
              child: Text(SS.login.userId == state.authorId ? S.current.tapUploadThemeBackground : '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
            ),
          ),
        );
      },
    );
  }

  ///用户信息
  Widget userInfo(BuildContext context){
    return GetBuilder<UserCenterController>(
      id: 'userInfo',
      builder: (_) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(right: 10.rpx),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: isAttentionRx(),
                                replacement: AppImage.asset("assets/images/plaza/attention_no.png",width: 24.rpx,height: 24.rpx,),
                                child: AppImage.asset("assets/images/plaza/attention.png",width: 24.rpx,height: 24.rpx,),
                              ),
                              Container(
                                width: 44.rpx,
                                margin: EdgeInsets.only(left: 4.rpx),
                                alignment: Alignment.center,
                                child: Text(isAttentionRx() ? S.current.followed : S.current.attention,style: AppTextStyle.fs14b.copyWith(color: AppColor.black666),),
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
              margin: EdgeInsets.only(bottom: 12.rpx),
              child: Text(state.authorInfo.nickname,style: AppTextStyle.fs20b.copyWith(color: AppColor.blackBlue,height: 1),textAlign: TextAlign.center,),
            ),
            Visibility(
              visible: state.authorInfo.type.index != 0,
              child: Text("${controller.label()}   ${state.authorInfo.position ?? ''}",style: AppTextStyle.fs14m.copyWith(color: AppColor.black92,height: 1),),
            ),
            SizedBox(height: 8.rpx,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(state.userBasics.length, (i) {
                return SizedBox(
                  height: 85.rpx,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${state.userBasics[i]['name']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.black92),),
                      controller.basicsInfo(index: i),
                    ],
                  ),
                );
              }),
            ),
            Container(
              height: 1.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
              child: Text(S.current.userSignature,style: AppTextStyle.fs16b.copyWith(color: AppColor.blackBlue),),
            ),
            Obx(() => Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                      minHeight: 63.rpx
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(state.authorInfo.signature?.fixAutoLines() ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.blackBlue,),maxLines: state.isShow.value ? 3 :  null,),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Visibility(
                    visible: calculateTextWidth(context,state.authorInfo.signature ?? '') && state.isShow.value,
                    child: GestureDetector(
                      onTap: (){
                        state.isShow.value = false;
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: 21.rpx,
                        padding: EdgeInsets.only(left: 50.rpx),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: const Alignment(-0.2, 0),
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.white,
                              ],
                            )
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "... ",
                            style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Read more",
                                style: AppTextStyle.fs14m.copyWith(color: AppColor.primaryBlue,height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
            Container(
              height: 1.rpx,
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
        padding: EdgeInsets.only(left: 16.rpx,bottom: 4.rpx),
        child: Text(S.current.personalPost,style: AppTextStyle.fs16b.copyWith(color: AppColor.blackBlue),),
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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.current.talkToMe1v1,style: AppTextStyle.fs14m.copyWith(color: AppColor.black666),),
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
                        text: "${S.current.realTime}\n${S.current.voice}",
                        textStyle: AppTextStyle.fs16b.copyWith(color: Colors.white,height: 1.18,),
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
                        text: S.current.video1V1Chat,
                        textStyle: AppTextStyle.fs16b.copyWith(color: Colors.white,),
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

  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行
  bool calculateTextWidth(BuildContext context, String value,){
    if(value.isEmpty){
      return false;
    }

    TextPainter painter = TextPainter(
      maxLines: 3,
      text: TextSpan(
        text: value,
        style: AppTextStyle.fs14m.copyWith(color: AppColor.blackBlue,height:1.5),
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: Get.width-32.rpx);
    return painter.didExceedMaxLines;
  }
}

extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}