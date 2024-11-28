import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/private_photo/widget/private_pay_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/event/event_bus.dart';
import '../../../common/event/event_constant.dart';
import '../../../common/extension/get_extension.dart';
import '../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../common/network/api/plaza_api.dart';
import '../../../common/paging/default_paging_controller.dart';
import '../../../common/routes/app_pages.dart';
import '../../../common/service/service.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/common_bottom_sheet.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/payment_password_keyboard.dart';
import '../dating_hall/dating_hall_controller.dart';
import '../user_center/user_center_controller.dart';
import 'private_photo_state.dart';

class PrivatePhotoController extends GetxController  with GetAutoDisposeMixin, UserAttentionMixin{
  final PrivatePhotoState state = PrivatePhotoState();
  final controller = Get.find<RectifyTheWorkplaceController>();
  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );
  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    autoDisposeWorker(
        EventBus().listen(kEventInvitationSuccess,(val){
          pagingController.refresh();
        })
    );
    super.onInit();
  }
  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    if(state.communityIndex.value == 1){
      ///按时间排列
      getCommunityList(page: page,sort: 0);
    }else if(state.communityIndex.value == 2){
      myFollowListPage(page);
    }else{
      ///按点赞数排列
      getCommunityList(page: page , sort: 1);
    }
  }


  ///我的关注帖子列表
  void myFollowListPage(int page) async {
    final response = await PlazaApi.followList(
      page: page,
      size: pagingController.pageSize,
      type: 2
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///获取私房照列表列表
  Future<void> getCommunityList({
    required int page,
    required int sort,
  }) async {
    if(page == 1){
      pagingController.itemList?.clear();
    }
    String tag = "";
    for(var i = 0; i < controller.state.labelList.length; i++){
      tag += "${controller.state.styleList[controller.state.labelList[i]].id},";
    }
    final response = await PlazaApi.getCommunityList(
      gender: controller.state.filtrateIndex,
      minAge: controller.state.info?.value.likeAgeMin,
      maxAge: controller.state.info?.value.likeAgeMax,
      style: tag,
      currentPage: page,
      type: 2,
      pageSize: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    final itemList = List.of(pagingController.itemList!);
    if (like) {
      itemList[index] = itemList[index]
          .copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) + 1);
    } else {
      itemList[index] = itemList[index]
          .copyWith(
          isLike: like,
          likeNum: ((itemList[index].likeNum ?? 1) - 1) < 0 ? 0 : ((itemList[index].likeNum ?? 1) - 1)) ;
    }
    pagingController.itemList = itemList;
  }

  ///评论信息
  void setComment(String str, int index) async {
    final itemList = List.of(pagingController.itemList!);
    itemList[index] = itemList[index].copyWith(
        commentNum: (itemList[index].commentNum ?? 0) + 1
    );
    pagingController.itemList = itemList;
  }

  ///删除帖子
  void deleteCommunity(int id) async {
    final response = await PlazaApi.deleteCommunity(
        id: id
    );
    if (response.isSuccess) {
      var itemList = List.of(pagingController.itemList!);
      PlazaListModel? item;
      for (var element in itemList) {
        if(element.postId == id){
          item = element;
          break;
        }
      }
      itemList.remove(item);
      pagingController.itemList = itemList;
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///解锁
  void _unlockPrivate(int postId) async {
    final password = await PaymentPasswordKeyboard.show();
    if (password == null) {
      return;
    }

    Loading.show();
    final response = await PlazaApi.unlockPrivate(
      postId: postId,
      password: password,
    );
    Loading.dismiss();
    if (response.isSuccess) {
      SS.login.fetchMyInfo();
      EventBus().emit(kEventOpenVip);
      Get.offNamed(
        AppRoutes.orderPaymentResultPage,
        arguments: {
          "isSuccess": true,
          "vipOrderNo": response.data,
        },
      );
    } else {
      response.showErrorMessage();
    }
  }

  void showPayDialog(PlazaListModel item){
    PrivatePayDialog.show(item ,  () {
      if((item.price??0) > (SS.login.info?.balance ?? 0)){

        Get.toNamed(AppRoutes.walletPage, arguments: {
          'tabIndex': 0,
          'moneyValue': item.price,
        });
        return;
      }
      _unlockPrivate(item.postId!);
    });
  }
}
