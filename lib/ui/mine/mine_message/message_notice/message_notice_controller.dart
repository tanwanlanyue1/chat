import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/utils/app_link.dart';

import '../../../../common/network/api/api.dart';
import 'message_notice_state.dart';

class MessageNoticeController extends GetxController {
  final MessageNoticeState state = MessageNoticeState();
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

  //系统跳转
  onTapSystem(MessageList item){
    if(item.systemMessage?.jumpType == 1){
      AppLink.jump(item.systemMessage?.link ?? '');
    }else if(item.systemMessage?.jumpType == 2){
      AppLink.jump(item.systemMessage?.link ?? '',args: jsonDecode(item.systemMessage?.extraJson ?? ''));
    }
  }

  /// 获取列表数据
  ///type: 0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注，6系统公告，7评论消息(3和4)
  void fetchPage(int page) async {
    final response = await UserApi.getMessageList(
      type: 6,
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
