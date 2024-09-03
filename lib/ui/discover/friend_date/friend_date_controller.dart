import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/discover/friend_date/widget/draft_dialog.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'friend_date_state.dart';

class FriendDateController extends GetxController with GetAutoDisposeMixin{
  final FriendDateState state = FriendDateState();

  //分页控制器
  final pagingController = DefaultPagingController<AppointmentModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  //发布邀约
  void onTapInvitation() {
    Get.toNamed(AppRoutes.releaseInvitation);
  }

  //类型名称
  String typeTitle(int index){
    String title = state.typeList.firstWhere((type) => type['type'] == index)['title'];
    if(title.length > 3){
      return "${title.substring(0, 2)}\n${title.substring(2)}";
    }else{
      return title;
    }
  }
  //标签分割
  String labelSplit(String text) {
    if(text.isEmpty){
      return '';
    }
    List<String> parts = text.split(',');
    List<String> hashtagParts = parts.map((part) => '#${part.trim()}').toList();
    return hashtagParts.join(' ');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    autoDisposeWorker(
      EventBus().listen(kEventReleaseSuccess,(val){
        fetchPage(1);
      })
    );
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  //设置排序
  void setSort(int i){
    if(state.sortIndex.contains(state.sortList[i]['type'])){
      state.sortIndex.remove(state.sortList[i]['type']);
    }else{
      state.sortIndex.add(state.sortList[i]['type']);
    }
    fetchPage(1);
  }

  ///获取约会列表
  void fetchPage(int page) async {
    Loading.show();
    AppointmentModel? res;
    if(page == 1){
      pagingController.itemList?.clear();
      res = await getOneself();
    }
    final response = await DiscoverApi.appointmentList(
      type: state.typeIndex.value > -1 ? state.typeList[state.typeIndex.value]['type'] : null,
      subTypes: state.sortIndex,
      page: page
    );
    Loading.dismiss();
    if (response.isSuccess) {
      final items = response.data ?? [];
      if(res != null){
        items.insert(0, res);
      }
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///获取自己的邀约
  Future<AppointmentModel?> getOneself() async {
    final response = await DiscoverApi.getOneself();
    if (response.isSuccess) {
      return response.data;
    }
  }

  //选择更多
  Future<void> selectMore(int? uid,int id) async {
    var more = (uid == state.userInfo?.uid) ? [S.current.deletePublisher,] : [S.current.privateOne, S.current.reportComplaint];
    Get.bottomSheet(
      CommonBottomSheet(
        titles: more,
        onTap: (index) async {
          if(uid == state.userInfo?.uid && index == 0){
            delAppointment(id);
          }
          if(index == 0){
            ChatManager().startChat(userId: uid!);
          }else{
            Get.toNamed(AppRoutes.mineFeedbackPage);
          }
        },
      ),
    );
  }

  //点击参与
  onTapParticipation(AppointmentModel item){
    if(state.userInfo?.type.index != 2){
      DraftDialog.show(item: item);
    }else{
      Loading.showToast(S.current.theDateOnlyUsersBeauties);
    }
  }

  ///删除邀约
  void delAppointment(int id) async {
    final response = await DiscoverApi.delAppointment(
      id: id
    );
    if (response.isSuccess) {
      var itemList = List.of(pagingController.itemList!);
      AppointmentModel? item;
      for (var element in itemList) {
        if(element.id == id){
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
}
