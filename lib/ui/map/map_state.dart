import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';

import '../../common/network/api/api.dart';

class MapState {

  ///当前地图中心点位置（Google总部）
  final cameraPositionRx = const CameraPosition(
    target: LatLng(37.42204555144066, -122.08531347369296),
    zoom: 16,
  ).obs;

  Set<Marker> markers = {};
  ///地点列表
  final placeListRx = <PlaceModel>[].obs;

  ///当前选中的地点
  final selectedPlaceRx = Rxn<PlaceModel>();

  ///搜索关键字
  final keywordRx = ''.obs;

  ///中心点坐标
  String centerLocation = '';

  List<NearbyPostUserModel> nearbyPostUser = [];
}
