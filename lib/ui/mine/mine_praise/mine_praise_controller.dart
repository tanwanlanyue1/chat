import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';

import '../../../common/network/api/api.dart';
import 'mine_praise_state.dart';

class MinePraiseController extends GetxController {
  final MinePraiseState state = MinePraiseState();
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
  ///type: 0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注
  void fetchPage(int page) async {
    final response = await UserApi.getMessageList(
      type: 1,
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


}
