import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_location_content.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_location_message.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'send_location_state.dart';

class SendLocationController extends GetxController {
  final SendLocationState state = SendLocationState();

  GoogleMapController? mapController;

  ///接收方用户ID
  final int userId;

  SendLocationController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    SS.location.requestPermission();
    final location = SS.location.locationRx();
    if (location != null) {
      state.initPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.4746,
      );
    }
    state.cameraPositionRx.value = state.initPosition;
    state.addressRx.value = 'Googleplex';
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  ///发送
  void onTapSend() async {
    final pos = state.cameraPositionRx();
    if(pos == null){
      Loading.showToast('请选择发送的位置');
      return;
    }

    Loading.show();
    final content = MessageLocationContent(
      longitude: pos.target.longitude,
      latitude: pos.target.latitude,
      address: state.addressRx(),
    );
    final result = await ChatManager().sendCustomMessage(
      customType: CustomMessageType.location.value,
      customMessage: jsonEncode(content.toJson()),
      conversationType: ZIMConversationType.peer,
      conversationId: userId.toString(),
    );
    Loading.dismiss();
    Get.back(result: result);
  }
}
