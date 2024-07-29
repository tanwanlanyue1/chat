import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/plaza_api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'classification_square_state.dart';

class ClassificationSquareController extends GetxController {
  final ClassificationSquareState state = ClassificationSquareState();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  ClassificationSquareController() {
    if (Get.arguments != null) {
      state.topicId = Get.arguments['topicItem'].id;
      state.topicType = Get.arguments['type'] == 0;
    }
  }

  @override
  void onInit() {
    
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  ///获取动态列表
  void fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    final response = await PlazaApi.getCommunityList(
        type: state.currentIndex.value,
        zoneId: state.topicType ? state.topicId : null,
        topicId: state.topicType ? null : state.topicId,
        currentPage: page,
        pageSize: pagingController.pageSize
    );
    if(response.isSuccess){
      final items = response.data ?? [];
      pagingController.appendPageData(items);
      // state.currentIndex.value = 0;
    }else{
      pagingController.error = response.errorMessage;
    }
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    var itemList = List.of(pagingController.itemList!);
    if (like) {
      itemList[index] = itemList[index]
          .copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) + 1);
    } else {
      itemList[index] = itemList[index]
          .copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) - 1);
    }
    pagingController.itemList = itemList;
  }

  ///收藏或者取消收藏
  void getCommentCollect(bool collect, int index) async {
    var itemList = List.of(pagingController.itemList!);
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
          collectNum:
          (itemList[index].collectNum ?? 0) - 1);
    }
    pagingController.itemList = itemList;
  }
}
