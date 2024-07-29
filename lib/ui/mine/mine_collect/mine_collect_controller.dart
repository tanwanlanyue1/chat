import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';

import '../../../common/network/api/api.dart';
import 'mine_collect_state.dart';

class MineCollectController extends GetxController with GetSingleTickerProviderStateMixin{
  final MineCollectState state = MineCollectState();
  late final SlidableController slidableController;
  //分页控制器
  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    
    pagingController.addPageRequestListener(fetchPage);
    slidableController = SlidableController(this);
    super.onInit();
  }

  ///获取收藏列表
  void fetchPage(int page) async {
    final response = await UserApi.getCollectList(
      uid: SS.login.userId ?? 0,
      page: page,
      size: pagingController.pageSize,
    );
    if(response.isSuccess){
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    }else{
      pagingController.error = response.errorMessage;
    }
  }

  ///删除收藏
  void removeCollect(int index){
    List<PlazaListModel> item = List.of(pagingController.itemList!);
    item.removeAt(index);
    pagingController.itemList = item;
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    var itemList = List.of(pagingController.itemList!);
    if (like) {
      itemList[index] = itemList[index].copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) + 1
      );
    } else {
      itemList[index] = itemList[index].copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) - 1
      );
    }
    pagingController.itemList = itemList;
  }

  onTapDelete(){
    state.all = !state.all;
    update();
  }
}
