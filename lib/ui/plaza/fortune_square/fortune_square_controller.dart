import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/ui/plaza/widgets/filtrate_bottom_sheet.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../dating_hall/dating_hall_controller.dart';
import 'fortune_square_state.dart';

class FortuneSquareController extends GetxController
    with GetSingleTickerProviderStateMixin,GetAutoDisposeMixin, UserAttentionMixin{
  final FortuneSquareState state = FortuneSquareState();
  late TabController tabController;
  final controller = Get.find<RectifyTheWorkplaceController>();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );


  @override
  void onInit() {
    tabController = TabController(length: state.communityTitle.length, vsync: this,);
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
    if(tabController.index == 1){
      myFollowListPage(page);
    }else if(tabController.index == 2){
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
    final response = await PlazaApi.getCommunityList(
      gender: controller.state.filtrateIndex,
      minAge: controller.state.info?.value.likeAgeMin,
      maxAge: controller.state.info?.value.likeAgeMax,
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
  Future<void> selectMore(int? uid,int id) async {
    var more = (uid == state.userInfo?.uid) ? [S.current.deletePublisher] : ['取消关注','发起聊天'];
    Get.bottomSheet(
      CommonBottomSheet(
        titles: more,
        onTap: (index) async {
          if(uid == state.userInfo?.uid && index == 0){
            deleteCommunity(id);
          }
          if(index == 0) {
            toggleAttention(uid!).then((value) => {
              pagingController.onRefresh()
            });
          }else if(index == 1){
            MessageListPage.go(userId: uid!);
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
    List<CommentListModel> comment = itemList[index].commentList ?? [];
    comment.insert(0, CommentListModel.fromJson({
          "content":str,
          "nickname":SS.login.info?.nickname,
    }));
    itemList[index] = itemList[index].copyWith(
        commentList: comment
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
            pagingController.onRefresh();
          },
        )
    );
  }
}
