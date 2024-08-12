import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'contact_state.dart';

class ContactController extends GetxController {
  final ContactState state = ContactState();
  final editingController = TextEditingController();

  //分页控制器
  late final pagingController = DefaultPagingController<UserModel>(
    pageSize: 20,
    refreshController: RefreshController(),
  )..addPageRequestListener(fetchPage);

  @override
  void onInit() {
    super.onInit();
  }

  void fetchPage(int page) async {
    final response = await UserApi.attentionOrFansList(
      type: 0,
      page: page,
      size: pagingController.pageSize,
    );
    if(response.isSuccess){
      pagingController.appendPageData(response.data ?? []);
    }else{
      pagingController.error = response.errorMessage;
    }
  }

  void doSearch() async {
    final text = editingController.text.trim();
    if(text.isEmpty){
      return;
    }
    final chatNo = int.tryParse(text);
    if(chatNo == null){
      Loading.showToast('用户ID无效');
      return;
    }

    Loading.show();
    final response = await UserApi.queryUserByChatNo(chatNo);
    Loading.dismiss();
    if(response.isSuccess){
      final userId = response.data?.uid;

    }else{
      response.showErrorMessage();
    }
  }

  void onTapItem(int index) {
    final users = [19, 20, 21];
    final id = users.elementAtOrNull(index);
    if (id != null && id != SS.login.userId) {
      MessageListPage.go(
        conversationId: id.toString(),
        conversationType: ZIMConversationType.peer,
      );
    }
  }
}
