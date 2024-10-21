import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'send_location_controller.dart';
import 'send_location_state.dart';

///发送位置消息
class SendLocationPage extends GetView<SendLocationController> {
  const SendLocationPage({super.key});

  SendLocationState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发送位置'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildMap(),
          buildMarker(),
          buildSendButton(),
        ],
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: state.initPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      onMapCreated: (GoogleMapController mapController) {
        controller.mapController = mapController;
      },
      onCameraMove: state.cameraPositionRx.call,
    );
  }

  Widget buildMarker() {
    return Padding(
      padding: FEdgeInsets(),
      child: AppImage.asset(
        'assets/images/chat/ic_chat_location.png',
        width: 40.rpx,
      ),
    );
  }

  Widget buildSendButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: FEdgeInsets(
          horizontal: 24.rpx,
          bottom: Get.padding.bottom + 24.rpx,
        ),
        child: CommonGradientButton(
          height: 50.rpx,
          onTap: controller.onTapSend,
          text: '确认',
        ),
      ),
    );
  }
}
