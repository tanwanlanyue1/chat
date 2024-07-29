import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';
import 'mine_comment_state.dart';

class MineCommentController extends GetxController {
  final MineCommentState state = MineCommentState();
  //分页控制器
  final pagingController = DefaultPagingController<MessageList>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  /// 获取列表数据
  ///type: 0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注，6系统公告，7评论消息(3和4)
  void fetchPage(int page) async {
    final response = await UserApi.getMessageList(
      type: 7,
    );
    if (response.isSuccess) {
      if (page == 1) {
        pagingController.itemList?.clear();
      }
      pagingController.setPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///删除消息
  void removeCollect(int id,int index) async {
    final response = await UserApi.deleteMessage(
      ids: '$id',
    );
    if(response.isSuccess){
      List<MessageList> item = List.of(pagingController.itemList!);
      item.removeAt(index);
      pagingController.itemList = item;
    }else{
      response.showErrorMessage();
    }
  }


  ///评论
  /// pid:根评论id
  /// replyId:回复的评论id
  /// postId:帖子id
  Future<void> postComment({int? postId,int? pid,int? replyId,String? str}) async {
    SS.login.requiredAuthorized(() async {
      if(str?.isEmpty ?? true){
        return  Loading.showToast("回复内容不能为空!");
      }
      Loading.show();
      final response = await PlazaApi.postComment(
        pid: pid,
        replyId: replyId,
        postId: postId,
        content: str,
      );
      if(response.isSuccess){
        Loading.showToast(response.data);
        Get.back();
      }else{
        response.showErrorMessage();
      }
      Loading.dismiss();
    });
  }
}
