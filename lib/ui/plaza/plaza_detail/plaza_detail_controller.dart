import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import 'plaza_detail_state.dart';
import 'widgets/review_dialog.dart';

class PlazaDetailController extends GetxController {
  final PlazaDetailState state = PlazaDetailState();
  //聊天控制器
  final TextEditingController chatController = TextEditingController();
  FocusNode chatFocusNode = FocusNode();
  final pagingController = DefaultPagingController<CommentListModel>.single(
    refreshController: RefreshController()
  );

  PlazaDetailController({
    required int communityId,
    required int userId
    }){
    state.communityId = communityId;
    state.authorId = userId;
  }

  ///拉起弹窗
  void clean({CommentListModel? item,bool all = false}){
    if(item != null){
      state.rootId = item.pid ?? item.id;
      state.replyId = item.pid != null ? item.id : null;
      state.hint = "@${item.nickname}:";
    }else{
      state.hint = '';
      state.rootId = all ? state.rootId : null;
      state.replyId = null;
    }
    chatController.text = '';
    Future.delayed(const Duration(milliseconds: 300),(){
      chatFocusNode.requestFocus();
    });
    ReviewDialog.show();
  }

  //标签跳转
  void labelTap(){
    Map item = {
      "title": state.articleDetail.topicName,
      "id": state.articleDetail.topicId,
      "viewNum": state.articleDetail.topicHot
    };
    TopicModel topicItem = TopicModel.fromJson(item);
    Get.toNamed(AppRoutes.classificationSquarePage,arguments: {"topicItem":topicItem,"type":1});
  }

  @override
  void onInit() {
    
    if(SS.login.userId != state.authorId){
      getIsAttention();
    }
    getUserInfo();
    pagingController.addPageRequestListener((_) => fetchPage());
    chatFocusNode.addListener(() {
      update(['bottom']);
    });
    super.onInit();
  }

  void fetchPage() async {
    getCommentList();
    getCommunityDetail();
  }

  ///获取动态详情
  Future<void> getCommunityDetail() async {
    final response = await PlazaApi.getCommunityDetail(
      id: state.communityId
    );
    if(response.isSuccess){
      state.articleDetail = response.data ?? PlazaListModel.fromJson({});
      update();
    }else{
      response.showErrorMessage();
    }
  }

  ///获取作者信息
  Future<void> getUserInfo() async {
    final response = await UserApi.info(
        uid: state.authorId
    );
    if(response.isSuccess){
      state.authorInfo.value = response.data ?? UserModel.fromJson({});
    }
    update(['userInfo']);
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
    }
    update(['userInfo']);
    state.isAttention = !state.isAttention!;
  }

  ///点赞或者取消点赞
  /// type:点赞类型（1动态2评论）
  /// sub:是否点赞二级评论
  Future<void> getCommentLike({int type = 1,int? communityId,int? index,bool sub = false}) async {
    SS.login.requiredAuthorized(() async {
      final response = await PlazaApi.getCommentLike(
          id: communityId ?? state.communityId,
          type: type
      );
      if(response.isSuccess){
        if(response.data == 0){
          if(type == 1){
            state.articleDetail = state.articleDetail.copyWith(
                isLike: true,
                likeNum: (state.articleDetail.likeNum ?? 0) + 1
            );
          }
        }else{
          if(type ==1){
            state.articleDetail = state.articleDetail.copyWith(
                isLike: false,
                likeNum: (state.articleDetail.likeNum ?? 0) -1
            );
          }
        }
        getCommentList();
        update();
      }else{
        response.showErrorMessage();
      }
    });
  }

  ///收藏或者取消收藏
  Future<void> getCommentCollect() async {
    SS.login.requiredAuthorized(() async {
      final response = await PlazaApi.getCommentCollect(
        id: state.communityId,
      );
      if(response.isSuccess){
        if(response.data == 0){
          state.articleDetail = state.articleDetail.copyWith(
              isCollect: true,
              collectNum: (state.articleDetail.collectNum ?? 0) + 1
          );
        }else{
          state.articleDetail = state.articleDetail.copyWith(
              isCollect: false,
              collectNum: (state.articleDetail.collectNum ?? 0) -1
          );
        }
        update();
      }else{
        response.showErrorMessage();
      }
    });
  }

  ///获取广场评论列表
  ///type（默认0热门，1最新，2最早
  Future<void> getCommentList() async {
    final response = await PlazaApi.getCommentList(
      id: state.communityId,
      type: state.dropType,
    );
    if(response.isSuccess){
      var res = response.data ?? [];
      pagingController.setPageData(res);
      final data = res.firstWhereOrNull((element) => element.id == state.review.value.id);
      state.review.value = data ?? state.review.value;
    }else{
      pagingController.error = response.errorMessage;
    }
  }

  ///评论
  /// pid:根评论id
  /// replyId:回复的评论id
  /// postId:帖子id
  Future<void> postComment({int? pid,int? replyId,}) async {
    SS.login.requiredAuthorized(() async {
      if(chatController.text.isEmpty){
        return  Loading.showToast("评论内容不能为空!");
      }
      final response = await PlazaApi.postComment(
        pid: state.rootId,
        replyId: state.replyId,
        postId: state.communityId,
        content: (state.hint ?? '') +chatController.text,
      );
      if(response.isSuccess){
        Loading.showToast(response.data);
        getCommentList();
        chatController.text = '';
        chatFocusNode.unfocus();
        Get.back();
        getCommunityDetail();
      }else{
        response.showErrorMessage();
      }
    });
  }

  @override
  void onClose() {
    
    chatFocusNode.removeListener(() {});
    super.onClose();
  }
}
