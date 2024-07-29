import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/advertising_swiper.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'fortune_square_controller.dart';

///运势广场
class FortuneSquareView extends StatelessWidget {
  FortuneSquareView({Key? key}) : super(key: key);

  final controller = Get.put(FortuneSquareController());
  final state = Get.find<FortuneSquareController>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.brown32, AppColor.brown14, AppColor.brown14, AppColor.brown14],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTopic(),
                    hotTopic(),
                    AdvertisingSwiper(position: 2,),
                    topicClassify(),
                  ],
                ),
              ),
            ),
            PagedSliverList(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_,item,index){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                      child: PlazaCard(
                        item: item,
                        isCollect: (collect){
                          controller.getCommentCollect(collect,index);
                        },
                        isLike: (like){
                          controller.getCommentLike(like, index);
                        },
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  ///话题类型
  Widget buildTopic(){
    return ObxValue((topicList) => Visibility(
      visible: topicList.isNotEmpty,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.rpx),
        height: topicList.length < 3 ? 60.rpx : 130.rpx,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: topicList.length < 3 ? 1 : 2,
            mainAxisSpacing: 10.rpx,
            crossAxisSpacing: 10.rpx,
            mainAxisExtent: 110.rpx
          ),
          itemCount: topicList.length,
          itemBuilder: (_, index) {
            var item = topicList[index];
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 8.rpx,right: 8.rpx),
                width: 110.rpx,
                height: 80.rpx,
                decoration: BoxDecoration(
                    image: AppDecorations.backgroundImage("assets/images/plaza/prefecture.png"),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("${item.title} ",
                                style: AppTextStyle.fs16b.copyWith(color: Colors.white)),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("热度:${(item.viewNum ?? 0) > 1000 ? '${(item.viewNum!/1000).toStringAsFixed(1)}k' : item.viewNum}",
                              style: AppTextStyle.fs12m.copyWith(color: const Color(0xCCFFFFFF))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.rpx,left: 2.rpx),
                      child: AppImage.network(
                        "${item.image}",
                        width: 34.rpx,
                        height: 34.rpx,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Get.toNamed(AppRoutes.classificationSquarePage,arguments: {"topicItem":topicList[index],"type":0});
              },
            );
          },
        ),
      ),
    ), state.topicList);
  }

  ///热门话题
  Widget hotTopic(){
    return ObxValue((hotTopic) => Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffFFE1BF), AppColor.brown39],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.rpx))
          ),
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: AppImage.asset('assets/images/plaza/topic_icon.png',width: 116.rpx,height: 116.rpx,),
              ),
              Container(
                margin: EdgeInsets.only(left: 12.rpx,bottom: 12.rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.rpx),
                          child: Text("热门话题",style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2.rpx,top: 2.rpx),
                          child: AppImage.asset(
                            "assets/images/wish_pavilion/charm/item_hot.png",
                            width: 16.rpx,
                            height: 16.rpx,
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 12.rpx,
                      runSpacing: 12.rpx,
                      children: List.generate(hotTopic.length, (i) {
                        var item = hotTopic[i];
                        return GestureDetector(
                          onTap: (){
                            Get.toNamed(AppRoutes.classificationSquarePage,arguments: {"topicItem":hotTopic[i],"type":1});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColor.brown35,
                                    AppColor.brown2,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1), // 阴影颜色
                                    spreadRadius: 5,
                                    blurRadius: 4,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(30.rpx))
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 9.rpx),
                            child: Text("${item.title}",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5)),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ), state.hotTopic);
  }

  ///话题分类
  Widget topicClassify(){
    return Container(
      padding: EdgeInsets.only(left: 12.rpx,top: 8.rpx),
      margin: EdgeInsets.only(bottom: 1.rpx,top: 12.rpx),
      decoration: BoxDecoration(
        color: AppColor.brown2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.rpx),
          topRight: Radius.circular(8.rpx),
        ),
      ),
      alignment: Alignment.centerLeft,
      height: 38.rpx,
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        labelColor: AppColor.gray5,
        labelStyle: AppTextStyle.fs16b.copyWith(color: AppColor.gray5),
        unselectedLabelColor: AppColor.gray9,
        unselectedLabelStyle: AppTextStyle.fs16b.copyWith(color: AppColor.gray9),
        indicatorColor: AppColor.red1,
        indicatorPadding: EdgeInsets.only(right: 16.rpx,left: 4.rpx),
        indicatorWeight: 3.rpx,
        labelPadding: EdgeInsets.only(bottom: 8.rpx,right: 12.rpx),
        onTap: (val){
          state.communityType = val;
          controller.pagingController.refresh();
        },
        tabs: const [
          Text("最新"),
          Text("推荐"),
        ],
      ),
    );
  }
  
}
