import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map_state.dart';
import 'widget/circle_avatar_painter.dart';

class MapController extends GetxController {
  final MapState state = MapState();

  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-33.86, 151.20);
  late BitmapDescriptor customIcon;
  Set<Marker> markers = {};

  late final initPos = CameraPosition(
    //23.11320434898468, 113.27840806963145
    // target: LatLng(37.42796133580664, -122.085749655962),
    target: _center,
    zoom: 14.4746,
  );

  @override
  void onInit() {
    super.onInit();
    Permission.location.request();
    addMarker();
  }

  Future<void> addMarker() async {
    final uiImage = await UiImage.loadImage(SS.login.avatar);//30
    String nick = "张三吃饭";
    double textWidth = UiImage.getTextWidth(context: Get.context!,text: nick,style: TextStyle(fontSize: 14.rpx));
    double nameWidth = textWidth > 80 ? 110 : 34+textWidth;
    String name = UiImage.nickName(nick, textWidth > 80);
    final painter = CircleAvatarPainter(image: uiImage, displayName: name,size: Size(nameWidth.px, 36.px));
    final imageBytes = await painter.toImage(Size(110.px, 44.px));

    markers.add(
      Marker(
        markerId: MarkerId('1'),
        zIndex: 1,
        position: LatLng(-33.86, 151.2001),
        icon: BitmapDescriptor.fromBytes(imageBytes),
        // icon: customIcon,
      ),
    );
    update();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

}
