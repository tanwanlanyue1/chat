import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SendLocationState {

  ///初始地图中心点位置
  var initPosition = CameraPosition(
    //23.11320434898468, 113.27840806963145
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  ///当前地图中心点位置
  final cameraPositionRx = Rxn<CameraPosition>();

  ///地图中心点地址
  final addressRx = ''.obs;

}
