import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/network.dart';
import '../../../common/routes/app_pages.dart';
import 'mine_message_state.dart';

class MineMessageController extends GetxController {
  final MineMessageState state = MineMessageState();
  final refreshController = RefreshController();


  void onTapSetting() {
    Get.toNamed(AppRoutes.messageSettingPage);
  }

  void onTapSession(int index) {
    if(index==0){
      Get.toNamed(AppRoutes.messageSessionPage);
      state.items[0].unread = 0;
      update();
    }else{
      Get.toNamed(AppRoutes.messageNotice);
    }
  }

  void onTapOptions(String routeName,int index) {
    Get.toNamed(routeName);
    state.options[index].unread = 0;
    update();
  }

  @override
  void onInit() {
    fetchPage();
    super.onInit();
  }
  /// 获取列表数据
  /// page: 第几页
  void fetchPage() async {
    getMessagesCounts();
    getMessageList();
  }


  /// 获取用户未读消息数量
  /// type	消息类型:0系统消息，1赞，2收藏，3评论，4回复评论，5新增关注
  void getMessagesCounts() async {
    final response = await UserApi.getMessagesCounts();
    if (response.isSuccess) {
      List message = response.data ?? [];
      for (var e in message) {
        if(e['type'] == 0){
          state.items[0].unread = e['count'];
        }
        if(e['type'] == 1){
          state.options[2].unread = e['count'];
        }
        if(e['type'] == 5){
          state.options[0].unread = e['count'];
        }
        if(e['type'] == 3 || e['type'] == 4){
          state.options[1].unread += (e['count'] as int);
        }
      }
      update();
    }
  }

  //获取一条系统消息和公告
  void getMessageList() async {
    final responses = await Future.wait<ApiResponse>([
      UserApi.getMessageList(type: 0,size: 1),
      UserApi.getMessageList(type: 6, size: 1),
    ]);
    if (!responses.every((element) => element.isSuccess)) {
      responses.firstWhereOrNull((element) => !element.isSuccess)?.showErrorMessage();
      refreshController.refreshCompleted();
      return;
    }
    if(responses[0].data != null && responses[0].data.length != 0){
      state.items[0].detail = responses[0].data?[0].content ?? '';
      state.items[0].time = responses[0].data?[0].createTime ?? '';
    }
    if(responses[1].data != null && responses[1].data.length != 0){
      state.items[1].detail = responses[1].data?[0]?.systemMessage?.title ?? '';
      state.items[1].time = responses[1].data?[0]?.systemMessage?.createTime ?? '';
    }
    update();
    refreshController.refreshCompleted();
  }

}
