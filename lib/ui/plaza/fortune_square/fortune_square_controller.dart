import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/common/utils/show_dialog.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/map/map_page.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/ui/plaza/widgets/filtrate_bottom_sheet.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../dating_hall/dating_hall_controller.dart';
import 'fortune_square_state.dart';

class FortuneSquareController extends GetxController
    with GetAutoDisposeMixin, UserAttentionMixin{
  final FortuneSquareState state = FortuneSquareState();
  final controller = Get.find<RectifyTheWorkplaceController>();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );


  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    autoDisposeWorker(
        EventBus().listen(kEventInvitationSuccess,(val){
          pagingController.refresh();
        })
    );
    super.onInit();
  }

  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    if(state.communityIndex.value == 1){
      myFollowListPage(page);
    }else if(state.communityIndex.value == 2){
      myFetchPage(page);
    }else{
      getCommunityList(page: page);
    }
  }

  ///获取我的帖子列表
  void myFetchPage(int page) async {
    final response = await PlazaApi.getMyPostList(
      uid: SS.login.info?.uid ?? 0,
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///我的关注帖子列表
  void myFollowListPage(int page) async {
    final response = await PlazaApi.followList(
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///获取动态列表
  Future<void> getCommunityList({
    required int page,
  }) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    String tag = "";
    for(var i = 0; i < controller.state.labelList.length; i++){
      tag += "${controller.state.styleList[controller.state.labelList[i]].id},";
    }
    final response = await PlazaApi.getCommunityList(
      location: state.location,
      gender: controller.state.filtrateIndex,
      minAge: controller.state.info?.value.likeAgeMin,
      maxAge: controller.state.info?.value.likeAgeMax,
      style: tag,
      currentPage: page,
      pageSize: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //选择更多
  Future<void> selectMore(PlazaListModel item) async {
    var more = (item.uid == state.userInfo?.uid) ? [S.current.deletePublisher,S.current.duplicateRelease] : [S.current.unfollow,S.current.initiateChat];
    Get.bottomSheet(
      CommonBottomSheet(
        titles: more,
        onTap: (index) async {
          if(state.communityIndex.value == 1){
            if(index == 0) {
              toggleAttention(item.uid!).then((value) => {
                pagingController.onRefresh()
              });
            }else if(index == 1){
              ChatManager().startChat(userId: item.uid!);
            }
          }else{
            if(index == 0){
              ShowDialog.show(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 38.rpx).copyWith(bottom: 24.rpx),
                  child: Text(S.current.confirmDelete,style: AppTextStyle.fs18.copyWith(color: AppColor.black20),textAlign: TextAlign.center,),
                ),
                callBack: (){
                  Get.back();
                  deleteCommunity(item.postId!);
                }
              );
            }else{
              Get.toNamed(AppRoutes.releaseDynamicPage,arguments: {"item":item});
            }
          }
        },
      ),
    );
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    final itemList = List.of(pagingController.itemList!);
    if (like) {
      itemList[index] = itemList[index]
          .copyWith(
              isLike: like,
              likeNum: (itemList[index].likeNum ?? 0) + 1);
    } else {
      itemList[index] = itemList[index]
          .copyWith(
              isLike: like,
              likeNum: ((itemList[index].likeNum ?? 1) - 1) < 0 ? 0 : ((itemList[index].likeNum ?? 1) - 1)) ;
    }
    pagingController.itemList = itemList;
  }

  ///评论信息
  void setComment(String str, int index) async {
    final itemList = List.of(pagingController.itemList!);
    itemList[index] = itemList[index].copyWith(
        commentNum: (itemList[index].commentNum ?? 0) + 1
    );
    pagingController.itemList = itemList;
  }

  ///删除帖子
  void deleteCommunity(int id) async {
    final response = await PlazaApi.deleteCommunity(
        id: id
    );
    if (response.isSuccess) {
      var itemList = List.of(pagingController.itemList!);
      PlazaListModel? item;
      for (var element in itemList) {
        if(element.postId == id){
          item = element;
          break;
        }
      }
      itemList.remove(item);
      pagingController.itemList = itemList;
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  //筛选
  void onTapFiltrate(){
    Get.bottomSheet(
        isScrollControlled: true,
        FiltrateBottomSheet(
          callBack: (){
            Get.back();
            controller.state.filtrateIndex = (controller.state.filtrateIndex ?? -1);
            pagingController.onRefresh();
          },
        )
    );
  }

  ///设置地址
  void setLocation() async {
    PlaceModel? data = await MapPage.go(title: S.current.selectLocation);
    if(data != null){
      state.location = '${data.geometry?.location?.lng},${data.geometry?.location?.lat}';
      pagingController.onRefresh();
    }
  }
}
