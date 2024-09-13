import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'all_comments_state.dart';

class AllCommentsController extends GetxController  with UserAttentionMixin, GetAutoDisposeMixin{
  AllCommentsController({
    int? postId, //帖子
    int? userId //用户id
  }){
    state.postId = postId ?? 0;
    state.userId = userId ?? 0;
  }
  final AllCommentsState state = AllCommentsState();

  final pagingController = DefaultPagingController<CommentListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );


  @override
  void onInit() {
    getUserInfo();
    getIsAttention(state.userId);
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  /// 获取列表数据
  void _fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    final response = await PlazaApi.getCommentList(
      id: state.postId,
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
    final response = await UserApi.info(uid: state.userId);
    if (response.isSuccess) {
      state.authorInfo = response.data ?? UserModel.fromJson({});
      update(['userInfo']);
    }
  }

}
