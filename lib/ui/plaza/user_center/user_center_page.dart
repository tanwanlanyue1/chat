import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'user_center_controller.dart';

///广场-用户中心
class UserCenterPage extends StatelessWidget {
  final String? userId; //用户id
  UserCenterPage({Key? key,this.userId}) : super(key: key);

  final controller = Get.put(UserCenterController());
  final state = Get.find<UserCenterController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: <Widget>[
                Obx(() => SliverAppBar(
                  pinned: true,
                  leading: AppBackButton(brightness: state.isAppBarExpanded.value ? Brightness.dark : Brightness.light,),
                  actions: [
                    GestureDetector(
                      onTap: controller.upload,
                      child: AppImage.asset("assets/images/plaza/uploading.png",width: 24.rpx,height: 24.rpx,color: state.isAppBarExpanded.value ? Colors.black :Colors.white,),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(right: 16.rpx,left: 12.rpx),
                        child: AppImage.asset("assets/images/discover/more.png",width: 24.rpx,height: 24.rpx,color: state.isAppBarExpanded.value ? Colors.black :Colors.white,),
                      ),
                    ),
                  ],
                  expandedHeight: 260.rpx,
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
              ],
            ),
          ),
          voiceContainer()
        ],
      ),
    );
  }

  ///背景
  Widget backImage(){
    return SizedBox(
      height: 300.rpx,
      child: Swiper(
        autoplay: true,
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          return AppImage.asset(
            'assets/images/plaza/back_image.png',
            // align: Alignment.topCenter,
            // borderRadius: BorderRadius.circular(8.rpx),
            width: Get.width,
            height: 300.rpx,
            fit: BoxFit.fitWidth,
          );
        },
        itemCount: 3,
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
          print("i====$i");
        },
      ),
    );
  }

  ///用户信息
  Widget userInfo(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.rpx),
          topRight: Radius.circular(24.rpx),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.rpx),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.rpx),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 76.rpx,top: 8.rpx),
                    child: AppImage.asset(
                      "assets/images/mine/head_photo.png",
                      width: 80.rpx,
                      height: 80.rpx,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                AppImage.asset("assets/images/plaza/attention.png",width: 24.rpx,height: 24.rpx,),
                Container(
                  padding: EdgeInsets.only(left: 4.rpx),
                  child: Text("关注",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray30),),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Jeremy Lawrence",style: AppTextStyle.fs20b.copyWith(color: AppColor.gray5),),
              SizedBox(width: 8.rpx),
              AppImage.asset("assets/images/mine/safety.png",width: 16.rpx,height: 16.rpx,),
            ],
          ),
          Text("${S.current.goodGirl} 北京",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray9),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(state.userBasics.length, (i) => SizedBox(
              height: 85.rpx,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${state.userBasics[i]['name']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray9),),
                  Text("${state.userBasics[i]['data']}",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                ],
              ),
            )),
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
          RichText(
            text: TextSpan(
              text: '超级可爱的小魔仙，对各种新鲜事物非常感兴趣。超级可爱的小魔仙，对各种新鲜事物非常感兴趣。超级可爱的小魔仙，对各种新鲜事物...',
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: 14.rpx,
              ),
              children: [
                TextSpan(
                  text: 'Read more',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.rpx,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2.rpx,
            margin: EdgeInsets.only(top: 24.rpx,bottom: 16.rpx),
            color: AppColor.scaffoldBackground,
          ),
        ],
      ),
    );
  }

  ///个人帖子
  Widget creativeDynamics(){
    return Container(
      color: AppColor.scaffoldBackground,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.rpx),
            child: Text("个人帖子",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),),
          ),
          ...List.generate(4, (index) => PlazaCard())
        ],
      ),
    );
  }

  ///语音
  Widget voiceContainer(){
    return Container(
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
                Container(
                  width: 60.rpx,
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: CommonGradientButton(
                    height: 50.rpx,
                    text: "实时\n语音",
                  ),
                ),
                Expanded(
                  child: CommonGradientButton(
                    height: 50.rpx,
                    text: "视频1V1聊天",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}