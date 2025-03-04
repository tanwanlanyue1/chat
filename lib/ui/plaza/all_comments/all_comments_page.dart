import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/user_avatar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import '../widgets/review_dialog.dart';
import 'all_comments_controller.dart';

///全部评论
class AllCommentsPage extends StatelessWidget {
  int? postId;
  int? userId;
  AllCommentsPage({super.key,this.userId,this.postId});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCommentsController>(
      init: AllCommentsController(
          postId: postId,
          userId: userId
      ),
      global: false,
      builder: (controller){
        late final state = controller.state;
        return PopScope(canPop: false,
          onPopInvoked: (bool canPop) {
            if(canPop){
            } else {
              Navigator.of(context).pop(state.comments);
            }
          },child: Scaffold(
            backgroundColor: AppColor.scaffoldBackground,
            body: Column(
              children: [
                appBar(controller),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.pagingController.refreshController,
                    onRefresh: controller.pagingController.onRefresh,
                    child: PagedListView.separated(
                      pagingController: controller.pagingController,
                      padding: EdgeInsets.only(bottom: 8.rpx),
                      builderDelegate: DefaultPagedChildBuilderDelegate<CommentListModel>(
                          pagingController: controller.pagingController,
                          itemBuilder: (_,item,index){
                            return commentItem(item);
                          }
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 1.rpx,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: bottomComment(controller),
          ),);
      },
    );
  }

  Widget appBar(AllCommentsController controller){
    late final state = controller.state;
    return Container(
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
      color: Colors.white,
      height: 44.rpx+Get.mediaQuery.padding.top,
      margin: EdgeInsets.only(bottom: 8.rpx),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Get.back(result: state.comments);
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
              child: UserAvatar.circle(state.authorInfo.avatar ?? '',size: 36.rpx),
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
                  visible: state.authorInfo.gender.index != 0,
                  child: Visibility(
                    visible: state.authorInfo.gender.isFemale,
                    replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                    child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                  ),
                ),
                SizedBox(width: 2.rpx),
                Text("${state.authorInfo.age ?? ''}",style: AppTextStyle.fs12.copyWith(color: AppColor.black666),),
              ],
            ),
          ),
          Obx(() => Visibility(
            visible: SS.login.userId != state.userId,
            child: GestureDetector(
              onTap: ()=> controller.toggleAttention(state.userId),
              child: Container(
                decoration: BoxDecoration(
                    color: controller.isAttentionRx.value ? AppColor.gray39 : AppColor.textPurple,
                    borderRadius: BorderRadius.circular(20.rpx)
                ),
                width: 60.rpx,
                height: 32.rpx,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 16.rpx),
                child: Text(controller.isAttentionRx.value ? S.current.followed:S.current.attention,style: AppTextStyle.fs14r.copyWith(
                    color: controller.isAttentionRx.value ? AppColor.grayText : Colors.white),),
              ),
            ),
          ))
        ],
      ),
    );
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
                  child: UserAvatar.circle(item.avatar ?? '',size: 40.rpx),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40.rpx,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.nickname}',style: AppTextStyle.fs14m.copyWith(color: AppColor.black20),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      Row(
                        children: [
                          Visibility(
                            visible: item.gender != 0,
                            child: Container(
                              margin: EdgeInsets.only(right: 8.rpx),
                              child: Visibility(
                                visible: item.gender == 1,
                                replacement: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                                child: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                              ),
                            ),
                          ),
                          Text("${item.age ?? ''}",style: AppTextStyle.fs12.copyWith(color: AppColor.black92),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text(CommonUtils.getPostTime(time: item.createTime),style: AppTextStyle.fs12.copyWith(color: AppColor.black666))
            ],
          ),
          SizedBox(height: 12.rpx,),
          Text(item.content ?? '',style: AppTextStyle.fs14.copyWith(color: AppColor.black20,height: 1.5),),
        ],
      ),
    );
  }

  //底部评论
  Widget bottomComment(AllCommentsController controller){
    late final state = controller.state;
    return Container(
      height: 68.rpx,
      padding: EdgeInsets.only(right: 16.rpx,left: 16.rpx),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2.rpx,
            offset: Offset(0, -2.rpx),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: (){
          ReviewDialog.show(
              pid: state.postId,
              callBack:(val){
                if(val != null && val.isNotEmpty){
                  controller.pagingController.onRefresh();
                  state.comments = val;
                }
              }
          );
        },
        child: Center(
          child: Container(
            height: 36.rpx,
            decoration: BoxDecoration(
              color: AppColor.white8,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            padding: EdgeInsets.only(left: 16.rpx),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 3.rpx),
                  child: AppImage.asset("assets/images/plaza/write.png",width: 20.rpx,height: 20.rpx,),
                ),
                Text(S.current.writeYourComments,style: AppTextStyle.fs14.copyWith(color: AppColor.gray9),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
