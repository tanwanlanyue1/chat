import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'session_list_state.dart';

class SessionListController extends GetxController with GetAutoDisposeMixin{
  final SessionListState state = SessionListState();

  @override
  void onInit() {
    super.onInit();
    _refreshReady();
    if(state.isReadyRx.isFalse){
      autoCancel(ZIMKit().getConnectionStateChangedEventStream().listen((event) {
        _refreshReady();
      }));
    }
  }

  void _refreshReady(){
    if(state.isReadyRx.isFalse){
      final connectionState = ZIMKitCore.instance.connectionState;
      state.isReadyRx.value = connectionState == ZIMConnectionState.connected;
    }
  }

}
