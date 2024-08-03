import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';
import 'user_center_state.dart';

class UserCenterController extends GetxController {
  final UserCenterState state = UserCenterState();

  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  //获取月份
  int acquisitionMonth(PlazaListModel? item) {
    return DateUtil.getDateTime(item?.createTime ?? '')?.month ?? 0;
  }

  @override
  void onInit() {
    
    state.authorId = Get.arguments?['userId'] ?? (SS.login.userId ?? 0);
    getUserInfo();
    getIsAttention();
    getFollowFansCount();
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  ///获取创作列表
  void fetchPage(int page) async {
    final response = await UserApi.getCreateList(
      id: state.authorId,
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

  ///获取关注数和粉丝数和创作数
  Future<void> getFollowFansCount() async {
    // final response = await UserApi.getFollowFansCount(uid: state.authorId);
    // if (response.isSuccess) {
    //   state.creation = response.data;
    //   update(['userInfo']);
    // }
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
      if(response.data == 0){
        state.creation['fansCount'] = state.creation['fansCount']+1;
      }else{
        state.creation['fansCount'] = state.creation['fansCount']-1;
      }
    }
    state.isAttention = !state.isAttention;
    update(['userInfo']);
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
