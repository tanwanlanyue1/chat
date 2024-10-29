import 'package:collection/collection.dart';
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

      //系统公告设置未读
      final systemCount = SS.inAppMessage.latestSysNoticeRx()?.systemCount ?? 0;
      if(type == 6){
        list.forEachIndexed((index, element) {
          element.read = index < systemCount ? 0 : 1;
        });
      }

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
    final msg = item.systemMessage;
    if([1,2].contains(msg?.jumpType)){
      AppLink.jump(msg?.link ?? '',args: msg?.extraJson);
    }
  }

}
