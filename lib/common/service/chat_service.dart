import 'package:get/get.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'service.dart';

///聊天相关服务
class ChatService extends GetxService {
  ///连接状态
  final connectionStateRx = ZIMKitCore.instance.connectionState.obs;

  @override
  void onInit() {
    super.onInit();

    //监听连接状态
    ZIMKitCore.instance.getConnectionStateChangedEventStream().listen((event) {
      connectionStateRx.value = ZIMKitCore.instance.connectionState;
      if (connectionStateRx.value == ZIMConnectionState.connected) {
        updateUserInfo();
      }
    });
  }

  ///更新用户信息到IM服务器
  Future<void> updateUserInfo() async {
    final userInfo = SS.login.info;
    if (userInfo != null) {
      await ZIMKit().updateUserInfo(
        name: userInfo.nickname,
        avatarUrl: userInfo.avatar ?? '',
      );
    }else{
      AppLogger.w('updateUserInfo: 用户信息为空');
    }
  }
}
