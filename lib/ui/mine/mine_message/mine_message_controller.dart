import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../common/network/network.dart';
import 'mine_message_state.dart';

class MineMessageController extends GetxController with GetSingleTickerProviderStateMixin {
  final MineMessageState state = MineMessageState();
  final refreshController = RefreshController();
  ///0系统消息,6系统公告
  final int type;

  ///分页控制器
  late final pagingController = DefaultPagingController<MessageModel>(
    pageSize: 20,
    refreshController: RefreshController(),
  )..addPageRequestListener(fetchPage);

  MineMessageController({required this.type});

  void fetchPage(int page) async {
    final response = await UserApi.getMessageList(
      type: type,
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      final list = response.data ?? [];
      pagingController.appendPageData(list);
      if(page == 1){
        _markRead(list.firstOrNull);
      }
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  ///标记已读
  void _markRead(MessageModel? message){
    if(type == 6){
      message?.systemMessage?.id?.let(SS.inAppMessage.markReadSysNotice);
    }else{
      SS.inAppMessage.markReadSysMsg();
    }
  }

  void onTapMessage(MessageModel item){
    if(item.systemMessage?.jumpType == 1){
      AppLink.jump(item.systemMessage?.link ?? '');
    }else if(item.systemMessage?.jumpType == 2){
      AppLink.jump(item.systemMessage?.link ?? '',args: jsonDecode(item.systemMessage?.extraJson ?? ''));
    }
  }

  /// 获取用户未读消息数量
  /// type	消息类型:0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注
  void getMessagesCounts() async {
    final response = await UserApi.getMessagesCounts();
    if (response.isSuccess) {
      List message = response.data ?? [];
      update();
    }
  }

}
