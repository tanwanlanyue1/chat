import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:intl/intl.dart';
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
  SwiperController swiper = SwiperController();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  void upload(){
    if(SS.login.userId == state.authorId){
      UploadCoverDialog.show();
    }
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      double offset = scrollController.offset;
      double appBarHeight = 220.rpx;
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
      state.imgList = response.data?.images != null ? List<String>.from(jsonDecode(response.data?.images ?? '')) : [];
      state.userBasics = response.data?.type.index == 0 ? [
        {
          "name": S.current.userAge,
          "data":"age",
        },
        {
          "name": S.current.userGender,
          "data":"gender",
        },
        {
          "name": S.current.identity,
          "data": S.current.user,
        },
        {
          "name": S.current.site,
          "data":"position",
        },
      ] : state.userBasics;
      update();
      ChatUserManager().updateWithUserModels([state.authorInfo]);
    }
  }

  String label(){
    switch(state.authorInfo.type){
      case UserType.user:
        return S.current.personage;
      case UserType.beauty:
        return S.current.goodGirl;
      case UserType.agent:
        return S.current.brokerP;
    }
  }

  //简介信息
  Widget basicsInfo({required int index}){
    var info = jsonDecode(jsonEncode(state.authorInfo))[state.userBasics[index]['data']] ?? '-';
    if(index == 1){
      info = (info == 0) ? "-" : ((info == 1) ? S.current.male:S.current.female);
    }else if(info == '0.00' || info == '0'|| info == 0){
      info = '-';
    }
    if(state.authorInfo.type.isUser && index == 2){
      info = S.current.user;
    }
    if(!state.authorInfo.type.isUser && index == 2 && info != '-'){
      NumberFormat format = NumberFormat('0.#####');
      String formattedValue = format.format(double.parse(info));
      return Padding(
        padding: EdgeInsets.only(left: 4.rpx),
        child: RichText(
          text: TextSpan(
            text: formattedValue,
            style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue),
            children: <TextSpan>[
              TextSpan(
                text: "%",
                style: AppTextStyle.fs12m.copyWith(color: AppColor.blackBlue,),
              ),
            ],
          ),
        ),
      );
    }
    return Text('$info',style: AppTextStyle.fs16m.copyWith(color: AppColor.blackBlue),);
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

  ///评论信息
  void setComment(String str, int index) async {
    final itemList = List.of(pagingController.itemList!);
    List<CommentListModel> comment = itemList[index].commentList ?? [];
    comment.insert(0, CommentListModel.fromJson({
      "content":str,
      "nickname":SS.login.info?.nickname,
    }));
    itemList[index] = itemList[index].copyWith(
        commentList: comment,
        commentNum: (itemList[index].commentNum ?? 0) + 1
    );
    pagingController.itemList = itemList;
  }

  //上传封面图
  void updateInfoImage() async {
    if(state.imgList.isEmpty){
      Loading.showToast(S.current.pleaseSelectImage);
    }else{
      final res = await UserApi.updateInfoFull(
        data: {
          "images": jsonEncode(state.imgList)
        },
      );
      if(res.isSuccess){
        state.authorInfo = state.authorInfo.copyWith(
            images: jsonEncode(state.imgList)
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          swiper.move(0);
        });
        update();
        SS.login.fetchMyInfo();
        Get.back();
      }else{
        res.showErrorMessage();
      }
    }
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
    // Loading.show();
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