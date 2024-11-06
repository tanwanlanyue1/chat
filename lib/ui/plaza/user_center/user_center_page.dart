import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_button.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/widgets/user_style.dart';
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
  int? userId;
  UserCenterPage({super.key,this.userId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCenterController>(
      init: UserCenterController(
        userId: userId
      ),
      global: false,
      builder: (controller){
        final state = controller.state;
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
                            background: backImage(controller),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Transform.translate(
                              offset: const Offset(0,1),
                              child: Container(
                                height: 10.rpx,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.rpx),
                                    topRight: Radius.circular(16.rpx),
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
                          userInfo(context,controller),
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
                                  height: 1.rpx,
                                  margin: EdgeInsets.only(left: 24.rpx,right: 16.rpx,bottom: 12.rpx),
                                  color: AppColor.scaffoldBackground,
                                ),
                              ],
                            ),
                          );
                        },
                        noItemsFoundIndicatorBuilder:(_){
                          return NoItemsFoundIndicator(
                            title: S.current.noData,
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
                          child: UserAvatar.circle(
                            state.authorInfo.avatar ?? '',
                            size: 32.rpx,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.isAppBarExpanded.value,
                        child: Center(
                          child: Text(state.authorInfo.nickname,style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue,height: 1),),
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: SS.login.userId == state.authorId,
                        child: InkWell(
                          onTap: ()=>controller.upload(controller),
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
          bottomNavigationBar: voiceContainer(controller),
        );
      },
    );
  }

  ///背景
  Widget backImage(UserCenterController controller){
    final state = controller.state;
    return SizedBox(
      height: 220.rpx,
      child: state.authorInfo.images != null && jsonDecode(state.authorInfo.images!).isNotEmpty?
      Swiper(
        autoplay: jsonDecode(state.authorInfo.images!).length > 1 ? true : false,
        controller: controller.swiper,
        index: state.swiperIndex,
        itemBuilder: (BuildContext context, int index) {
          return AppImage.network(
            jsonDecode(state.authorInfo.images!)[index],
            width: Get.width,
            height: 220.rpx,
            fit: BoxFit.cover,
            align: Alignment.topCenter,
          );
        },
        itemCount: jsonDecode(state.authorInfo.images!).length,
        pagination: jsonDecode(state.authorInfo.images!).length > 1 ?
        SwiperPagination(
            alignment:  Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 16.rpx,right: 16.rpx),
            builder: UserSwiperPagination(
              color: const Color(0xffD1D8E6),
              size: 6.rpx,
              activeSize:6.rpx,
              space: 6.rpx,
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
        onTap: ()=>controller.upload(controller),
        child: Container(
          height: 220.rpx,
          color: AppColor.black6,
          alignment: Alignment.center,
          child: Text(SS.login.userId == state.authorId ? S.current.tapUploadThemeBackground : '',style: AppTextStyle.fs14.copyWith(color: AppColor.gray9),),
        ),
      ),
    );
  }

  ///用户信息
  Widget userInfo(BuildContext context,UserCenterController controller){
    final state = controller.state;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.rpx).copyWith(top: 2.rpx),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 8.rpx),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.rpx,),
                      alignment: Alignment.center,
                      child: UserAvatar.circle(
                        state.authorInfo.avatar ?? '',
                        size: 52.rpx,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 52.rpx,
                        child: Column(
                          children: [
                            Container(
                              height: 16.rpx,
                              margin: EdgeInsets.only(top: 2.rpx,bottom: 12.rpx),
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: state.authorInfo.position != null ? 140.rpx:160.rpx
                                    ),
                                    child: Text(state.authorInfo.nickname,style: AppTextStyle.fs16b.copyWith(color: AppColor.blackBlue,height: 1.0),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                  Container(
                                    height: 12.rpx,
                                    padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                                    decoration: BoxDecoration(
                                        color: state.authorInfo.gender.iconColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(14.rpx)
                                    ),
                                    margin: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AppImage.asset(state.authorInfo.gender.icon ?? '',width: 8.rpx,height: 8.rpx),
                                        SizedBox(width: 2.rpx,),
                                        Text(
                                          "${state.authorInfo.age ?? ''}",
                                          style: AppTextStyle.fs10.copyWith(color: state.authorInfo.gender.index == 1 ? AppColor.primaryBlue:AppColor.textPurple,height: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: state.authorInfo.position != null && state.authorInfo.position?.length != 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.rpx,vertical: 2.rpx),
                                      decoration: BoxDecoration(
                                          color: AppColor.primaryBlue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(14.rpx)
                                      ),
                                      child: Text("${(state.authorInfo.position?.length ?? 0) < 5 ?
                                      state.authorInfo.position: state.authorInfo.position?.substring(0,5)}",
                                        style: AppTextStyle.fs8m.copyWith(color: AppColor.primaryBlue),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: state.authorInfo.nameplate.isNotEmpty,
                                  child: CachedNetworkImage(imageUrl: state.authorInfo.nameplate,height: 12.rpx),
                                ),
                                SizedBox(width: 4.rpx,),
                                Expanded(
                                  child: SizedBox(
                                    height: 20.rpx,
                                    child: UserStyle(styleList: state.authorInfo.styleList,all: true,),
                                  )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: 0 != state.authorInfo.type.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(state.userBasics.length, (i) {
                    return SizedBox(
                      height: 70.rpx,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${state.userBasics[i]['name']}",style: AppTextStyle.fs12.copyWith(color: AppColor.black92),),
                          Row(
                            children: [
                              Obx(() {
                                var fansNum = state.fansNum.value;
                                return controller.basicsInfo(index: i);
                              }),
                              Visibility(
                                visible: i==0,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.rpx,top: 2.rpx),
                                  child: OccupationWidget(occupation: UserOccupation.valueForIndex(state.authorInfo.occupation.index)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Visibility(
                visible: 0 != state.authorInfo.type.value,
                child: Container(
                  height: 1.rpx,
                  margin: EdgeInsets.only(top: 8.rpx,bottom: 12.rpx),
                  color: AppColor.scaffoldBackground,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 8.rpx),
                child: Text(S.current.userSignature,style: AppTextStyle.fs14b.copyWith(color: AppColor.blackBlue),),
              ),
              Obx(() => Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minHeight: 48.rpx
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(state.authorInfo.signature?.fixAutoLines() ?? '',style: AppTextStyle.fs10.copyWith(color: AppColor.black92,),maxLines: state.isShow.value ? 3 :  null,),
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
                          padding: EdgeInsets.only(left: 50.rpx,right: 14.rpx),
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
                              style: AppTextStyle.fs12.copyWith(color: AppColor.black92),
                              children: <TextSpan>[
                                TextSpan(
                                  text: S.current.readMore,
                                  style: AppTextStyle.fs10.copyWith(color: AppColor.primaryBlue,height: 1.5),
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
                margin: EdgeInsets.only(top: 12.rpx,bottom: 12.rpx),
                color: AppColor.scaffoldBackground,
              ),
            ],
          ),
        ),
        Positioned(
          top: 1.rpx,
          right: 16.rpx,
          child: Visibility(
            visible: SS.login.userId != state.authorId,
            child: ObxValue((isAttentionRx) => GestureDetector(
              onTap: ()=> controller.toggleAttention(state.authorId),
              child: Container(
                decoration: BoxDecoration(
                    color: controller.isAttentionRx.value ? AppColor.gray39 : AppColor.textPurple,
                    borderRadius: BorderRadius.circular(26.rpx)
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: controller.isAttentionRx.value ? 8.rpx: 14.rpx,vertical: controller.isAttentionRx.value ? 3.rpx: 4.rpx),
                child: Text(controller.isAttentionRx.value ? S.current.followed:S.current.attention,style: AppTextStyle.fs12r.copyWith(
                    color: controller.isAttentionRx.value ? AppColor.grayText : Colors.white),),
              ),
            ),controller.isAttentionRx),
          ),
        )
      ],
    );
  }

  ///个人帖子
  Widget creativeDynamics(){
    return Container(
      color: AppColor.scaffoldBackground,
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.rpx,bottom: 8.rpx),
        child: Text(S.current.personalPost,style: AppTextStyle.fs14b.copyWith(color: AppColor.blackBlue),),
      ),
    );
  }

  ///语音
  Widget voiceContainer(UserCenterController controller){
    final state = controller.state;
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
            Text(S.current.talkToMe1v1,style: AppTextStyle.fs12.copyWith(color: AppColor.black92),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.rpx),
              child: CommonGradientButton(
                height: 50.rpx,
                text: S.current.findChat,
                onTap: (){
                  ChatManager().startChat(userId: state.authorId);
                },
                textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white,),
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
        style: AppTextStyle.fs14.copyWith(color: AppColor.blackBlue,height:1.5),
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