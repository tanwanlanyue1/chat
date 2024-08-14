import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';
import '../widgets/upload_cover.dart';
import 'user_center_state.dart';

class UserCenterController extends GetxController with UserAttentionMixin, GetAutoDisposeMixin{
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
    getIsAttention(state.authorId);
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

///用户关注Mixin
mixin UserAttentionMixin on GetxController implements GetAutoDisposeMixin{

  ///是否已关注
  final isAttentionRx = false.obs;

  @override
  void onInit(){
    super.onInit();
    autoDisposeWorker(EventBus().listen(kEventIsAttention, (data) {
      isAttentionRx.value = data == true;
    }));
  }

  ///是否已关注该用户
  Future<bool> getIsAttention(int userId) async {
    final response = await UserApi.isAttention(uid: userId);
    if (response.isSuccess) {
      isAttentionRx.value = response.data;
    }
    return isAttentionRx();
  }

  ///切换 关注，取消关注
  ///- return true关注，false取消关注
  Future<bool> toggleAttention(int userId) async {
    Loading.show();
    final response = await UserApi.attention(uid: userId);
    Loading.dismiss();
    if (!response.isSuccess) {
      response.showErrorMessage();
    }else{
      isAttentionRx.value = response.data == 0;
      EventBus().emit(kEventIsAttention,isAttentionRx());
    }
    return isAttentionRx();
  }


}