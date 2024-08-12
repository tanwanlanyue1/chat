import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/widgets/ad_dialog.dart';

import '../../../common/network/api/model/plaza/talk_plaza.dart';
import 'fortune_square_state.dart';

class FortuneSquareController extends GetxController
    with GetSingleTickerProviderStateMixin,GetAutoDisposeMixin {
  final FortuneSquareState state = FortuneSquareState();
  late TabController tabController;

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  void onTapTitle(){
    if(tabController.index == 2){

    }else{

    }
  }

  @override
  void onInit() {
    tabController = TabController(length: state.communityTitle.length, vsync: this,);
    pagingController.addPageRequestListener(_fetchPage);
    autoDisposeWorker(
        EventBus().listen(kEventInvitationSuccess,(val){
          pagingController.onRefresh();
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
    if(tabController.index == 2){
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

  ///获取动态列表
  Future<void> getCommunityList({
    required int page,
  }) async {
    final response = await PlazaApi.getCommunityList(
      type: state.communityType,
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

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    final itemList = List.of(pagingController.itemList!);
    // if (like) {
    //   itemList[index] = itemList[index]
    //       .copyWith(
    //           isLike: like,
    //           likeNum: (itemList[index].likeNum ?? 0) + 1);
    // } else {
    //   itemList[index] = itemList[index]
    //       .copyWith(
    //           isLike: like,
    //           likeNum: ((itemList[index].likeNum ?? 1) - 1) < 0 ? 0 : ((itemList[index].likeNum ?? 1) - 1)) ;
    // }
    pagingController.itemList = itemList;
  }

}
