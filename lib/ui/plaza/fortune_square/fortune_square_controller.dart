import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/widgets/ad_dialog.dart';

import '../../../common/network/api/model/plaza/talk_plaza.dart';
import 'fortune_square_state.dart';

class FortuneSquareController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final FortuneSquareState state = FortuneSquareState();
  late TabController tabController;

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    pagingController.addPageRequestListener(_fetchPage);
    startupCarousel();
    super.onInit();
  }

  /// 获取广告弹窗
  void startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 7,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"7");
      }
    }
  }
  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if (page == 1) {
      getZoneList();
      getTopicList();
    }
    getCommunityList(page: page);
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

  ///获取专区列表
  Future<void> getZoneList() async {
    final response = await PlazaApi.getZoneList();
    if (response.isSuccess) {
      state.topicList.value = response.data ?? [];
    }
  }

  ///获取话题列表
  Future<void> getTopicList() async {
    final response = await PlazaApi.getTopicList();
    if (response.isSuccess) {
      state.hotTopic.value = response.data ?? [];
    }
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

  ///收藏或者取消收藏
  void getCommentCollect(bool collect, int index) async {
    final itemList = List.of(pagingController.itemList!);
    if (collect) {
      itemList[index] = itemList[index]
          .copyWith(
              isCollect: collect,
              collectNum:
                  (itemList[index].collectNum ?? 0) + 1);
    } else {
      itemList[index] = itemList[index]
          .copyWith(
              isCollect: collect,
            collectNum: ((itemList[index].collectNum ?? 1) - 1) < 0 ? 0 : ((itemList[index].collectNum ?? 1) - 1)) ;
    }
    pagingController.itemList = itemList;
  }
}
