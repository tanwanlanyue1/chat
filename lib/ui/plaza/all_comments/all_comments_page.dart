import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import '../widgets/review_dialog.dart';
import 'all_comments_controller.dart';

///全部评论
class AllCommentsPage extends StatelessWidget {
  AllCommentsPage({Key? key}) : super(key: key);

  final controller = Get.find<AllCommentsController>();
  final state = Get.find<AllCommentsController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          appBar(),
          Expanded(
            child: SmartRefresher(
                controller: controller.pagingController.refreshController,
                onRefresh: controller.pagingController.onRefresh,
                child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate: DefaultPagedChildBuilderDelegate<CommentListModel>(
                      pagingController: controller.pagingController,
                      itemBuilder: (_,item,index){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                          child: commentItem(item),
                        );
                      }
                  ),
                ),
            ),
          ),
          //commentItem()
        ],
      ),
      bottomNavigationBar: bottomComment(),
    );
  }

  Widget appBar(){
    return GetBuilder<AllCommentsController>(
      id: 'userInfo',
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
          color: Colors.white,
          height: 44.rpx+Get.mediaQuery.padding.top,
          margin: EdgeInsets.only(bottom: 8.rpx),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: AppImage.asset(
                  width: 64,
                  height: 24,
                  'assets/images/common/back_black.png',
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.userCenterPage, arguments: {
                    'userId': state.userId,
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(state.authorInfo.avatar ?? '',width: 36.rpx,height: 36.rpx,),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 140.rpx),
                      child: Text(state.authorInfo.nickname,style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    ),
                    SizedBox(width: 4.rpx),
                    Visibility(
                      visible: state.authorInfo.gender.isFemale,
                      replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                      child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                    ),
                    SizedBox(width: 2.rpx),
                    Text("${state.authorInfo.age ?? ''}",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                  ],
                ),
              ),
              Obx(() => Visibility(
                visible: SS.login.userId != state.userId,
                child: GestureDetector(
                  onTap: ()=> controller.toggleAttention(state.userId),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.textPurple,
                        borderRadius: BorderRadius.circular(20.rpx)
                    ),
                    width: 60.rpx,
                    height: 32.rpx,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 16.rpx),
                    child: Text(controller.isAttentionRx.value ? "已关注":"关注",style: AppTextStyle.fs14b.copyWith(color: Colors.white),),
                  ),
                ),
              ))
            ],
          ),
        );
      },);
  }

  //评论项
  Widget commentItem(CommentListModel item){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.userCenterPage, arguments: {
                    'userId': item.uid,
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(item.avatar ?? '',width: 40.rpx,height: 40.rpx,shape: BoxShape.circle,),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40.rpx,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.nickname}',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      Row(
                        children: [
                          Visibility(
                            visible: item.gender == 1,
                            replacement: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                            child: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          ),
                          SizedBox(width: 8.rpx),
                          Text("${item.age ?? ''}",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text('${item.createTime?.substring(5,16)}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
            ],
          ),
          SizedBox(height: 12.rpx,),
          Text(item.content ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
        ],
      ),
    );
  }

  //底部评论
  Widget bottomComment(){
    return Container(
      height: 68.rpx,
      color: Colors.white,
      padding: EdgeInsets.only(right: 16.rpx,left: 16.rpx),
      child: GestureDetector(
        onTap: (){
          ReviewDialog.show(
              pid: state.postId,
              callBack:(val){
                controller.pagingController.onRefresh();
              }
          );
        },
        child: Center(
          child: Container(
            height: 36.rpx,
            decoration: BoxDecoration(
              color: AppColor.gray14,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            padding: EdgeInsets.only(left: 16.rpx),
            alignment: Alignment.centerLeft,
            child: Text("写下你的评论",style: AppTextStyle.fs14m.copyWith(color: AppColor.gray10),),
          ),
        ),
      ),
    );
  }
}
