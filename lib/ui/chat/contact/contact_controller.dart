import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'contact_state.dart';

class ContactController extends GetxController {
  final ContactState state = ContactState();
  final editingController = TextEditingController();

  //分页控制器
  final pagingController = DefaultPagingController<int>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  void fetchPage(int page) async {
    await Future.delayed(500.milliseconds);
    pagingController.appendPageData(List.generate(10, (index) => index + pagingController.length));
  }

  void doSearch() async{

  }

  void onTapItem(int index){
    final users = [19,20,21];
    final id = users.elementAtOrNull(index);
    if(id != null && id != SS.login.userId){
      Get.to(() => ZIMKitMessageListPage(
        conversationID: id.toString(),
        conversationType: ZIMConversationType.peer,
      ));
    }
  }

}
