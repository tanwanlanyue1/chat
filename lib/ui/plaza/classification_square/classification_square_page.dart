import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/home/widget/conversation_drawer.dart';
import 'package:guanjia/ui/plaza/widgets/plaza_card.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'classification_square_controller.dart';

///分类广场/话题广场
///type:0 专题，1：话题
class ClassificationSquarePage extends StatelessWidget {
  final TopicModel topicItem; //分类
  final int type; //分类
  ClassificationSquarePage({Key? key, required this.topicItem,required this.type}) : super(key: key);

  final controller = Get.put(ClassificationSquareController());
  final state = Get
      .find<ClassificationSquareController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color(0xffF6F8FE),
      extendBodyBehindAppBar: true,
      appBar: topBar(),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AppImage.asset(
                type == 0 ?
                "assets/images/plaza/classify_back.png":
                "assets/images/plaza/topic_back.png",
                height: 200.rpx,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  categoryIcon(),
                  classifyTab(),
                ],
              ),
            ],
          ),
          Expanded(
            child: classify(),
          )
        ],
      ),
      drawer: ConversationDrawer(),
    );
  }

  ///头部
  AppBar topBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: const AppBackButton(brightness: Brightness.light),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            SS.login.requiredAuthorized(() async {
              controller.scaffoldKey.currentState?.openDrawer();
            });
          },
          icon: AppImage.asset(
            "assets/images/plaza/conversation_white.png",
            width: 24.rpx,
            height: 24.rpx,
          ),
        ),
      ],
    );
  }

  ///类别图标
  Widget categoryIcon() {
    return Container(
      margin: EdgeInsets.only(left: 24.rpx),
      child: Row(
        children: [
          Visibility(
            visible: type == 0,
            child: Container(
              margin: EdgeInsets.only(right: 12.rpx),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.rpx))
              ),
              child: AppImage.network(
                topicItem.image ?? "assets/images/plaza/star_sign.png",
                width: 50.rpx,
                height: 50.rpx,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(type == 0 ? "${topicItem.title}" : "#${topicItem.title}",
                  style: TextStyle(fontSize: 24.rpx,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("热度：${topicItem.viewNum}",
                    style: TextStyle(fontSize: 14.rpx, color: Colors.white),
                    maxLines: 1,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///分类
  Widget classifyTab() {
    return ObxValue((currentIndex) =>Container(
      decoration: BoxDecoration(
        color: AppColor.brown2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rpx),
          topRight: Radius.circular(20.rpx),
        ),
      ),
      margin: EdgeInsets.only(top: 14.rpx),
      child: Row(
        children: List.generate(state.typeList.length, (index) =>
            GestureDetector(
              onTap: (){
                currentIndex.value = index;
                controller.fetchPage(1);
              },
              child: Container(
                height: 40.rpx,
                alignment: Alignment.center,
                width: 64.rpx,
                child: Text("${state.typeList[index]['name']}",
                  style: TextStyle(color: index == currentIndex.value
                      ? const Color(0xff333333)
                      : const Color(0xff999999), fontSize: 16.rpx,
                  fontWeight: index == currentIndex.value ? FontWeight.bold : FontWeight.normal
                  ),),
              ),
            ),),
      ),
    ), state.currentIndex);
  }

  ///分类列表
  Widget classify() {
    return SmartRefresher(
      controller: controller.pagingController.refreshController,
      onRefresh: controller.pagingController.onRefresh,
      child: PagedListView(
        pagingController: controller.pagingController,
        builderDelegate: DefaultPagedChildBuilderDelegate<PlazaListModel>(
            pagingController: controller.pagingController,
            itemBuilder: (_,item,index){
              return PlazaCard(
                item: item,
                isCollect: (collect){
                  controller.getCommentCollect(collect,index);
                },
                isLike: (like){
                  controller.getCommentLike(like, index);
                },
              );
            }
        ),
      ),
    );
  }
}
