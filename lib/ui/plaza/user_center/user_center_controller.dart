import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';
import '../widgets/upload_cover.dart';
import 'user_center_state.dart';

class UserCenterController extends GetxController {
  UserCenterController({
    int? userId //用户id
  }){
    state.authorId = userId ?? 0;
  }

  final UserCenterState state = UserCenterState();
  final ScrollController scrollController = ScrollController();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  void upload(){
    UploadCoverDialog.show();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      double offset = scrollController.offset;
      double appBarHeight = 260.rpx;
      state.isAppBarExpanded.value = (appBarHeight - kToolbarHeight) < offset;
    });
    getUserInfo();
    getIsAttention();
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  ///获取创作列表
  void fetchPage(int page) async {
    final response = await PlazaApi.getMyPostList(
      uid: state.authorId,
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

  ///获取作者信息
  Future<void> getUserInfo() async {
    final response = await UserApi.info(uid: state.authorId);
    if (response.isSuccess) {
      state.authorInfo = response.data ?? UserModel.fromJson({});
      update(['userInfo']);
    }
  }

  //简介信息
  String basicsInfo({required int index}){
    var info = jsonDecode(jsonEncode(state.authorInfo))[state.userBasics[index]['data']] ?? '-';
    if(index == 1){
      info = (info == 1) ? "男":"女";
    }else if(info == '0.00'){
      info = '-';
    }
    return info.toString();
  }

  ///是否关注作者
  Future<void> getIsAttention() async {
    final response = await UserApi.isAttention(uid: state.authorId);
    if (response.isSuccess) {
      state.isAttention = response.data;
      update(['userInfo']);
    }
  }

  ///关注作者
  Future<void> attention() async {
    Loading.show();
    final response = await UserApi.attention(uid: state.authorId);
    Loading.dismiss();

    if (!response.isSuccess) {
      response.showErrorMessage();
      return;
    }else{
      state.isAttention = !state.isAttention;
      EventBus().emit(kEventIsAttention,state.isAttention);
    }
    update(['userInfo']);
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    var itemList = List.of(pagingController.itemList!);
    if (like) {
      // itemList[index] = itemList[index]
      //     .copyWith(
      //     isLike: like,
      //     likeNum: (itemList[index].likeNum ?? 0) + 1);
    } else {
      // itemList[index] = itemList[index]
      //     .copyWith(
      //     isLike: like,
      //     likeNum: (itemList[index].likeNum ?? 0) - 1);
    }
    pagingController.itemList = itemList;
  }

}
