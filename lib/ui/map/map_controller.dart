import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/app_localization.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/network/api/open_api.dart';
import 'package:guanjia/common/network/httpclient/http_client.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map_state.dart';
import 'widget/circle_avatar_painter.dart';

class MapController extends GetxController {
  final MapState state = MapState();

  // 分页控制器
  late final pagingController = DefaultPagingController<PlaceModel>.single()
    ..addPageRequestListener(_fetchPlaces);
  final keywordEditingController = TextEditingController();
  final focusNode = FocusNode();

  GoogleMapController? mapController;

  var _isUserAction = false;
  Timer? _userActionTimer;

  MapController();

  late BitmapDescriptor customIcon;

  @override
  void onInit() {
    super.onInit();
    keywordEditingController.bindTextRx(state.keywordRx);
    //默认地图中心点
    final currentPos = SS.location.locationRx();
    if (currentPos != null) {
      state.cameraPositionRx.value = state.cameraPositionRx().copyWith(
        target: LatLng(currentPos.latitude, currentPos.longitude),
      );
    }
    //定位信息变更时，重新计算距离
    ever(SS.location.locationRx, (value) {
      if (value != null && pagingController.itemList?.isNotEmpty == true) {
        _computePlacesDistance(
          currentPos: value,
          places: pagingController.itemList ?? [],
        );
        pagingController.notifyListeners();
      }
    });

    //刷新设备定位
    SS.location.getCurrentPosition(isRequestPermission: true);
  }

  Future<void> addMarker(NearbyPostUserModel item) async {
    final uiImage = await UiImage.loadImage(item.avatar ?? '');
    String nick = item.nickname ?? '';
    double textWidth = UiImage.getTextWidth(context: Get.context!,text: nick,style: TextStyle(fontSize: 14.rpx));
    double nameWidth = textWidth > 80 ? 110 : 34+textWidth;
    String name = UiImage.nickName(nick, textWidth > 80);
    final painter = CircleAvatarPainter(image: uiImage, displayName: name,size: Size(nameWidth.px, 36.px));
    final imageBytes = await painter.toImage(Size(110.px, 44.px));

    state.markers.add(
      Marker(
        markerId: MarkerId('${item.uid}'),
        zIndex: 1,
        position: LatLng(SS.location.locationRx()!.latitude, SS.location.locationRx()!.longitude),
        icon: BitmapDescriptor.fromBytes(imageBytes),
      ),
    );
  }

  ///获取指定位置附近的帖子发布用户列表
  void getNearbyPostUserList() async {
    final response = await PlazaApi.getNearbyPostUserList(
        location: state.centerLocation
    );
    if (response.isSuccess) {
      state.nearbyPostUser = response.data ?? [];
      for(var i = 0; i < state.nearbyPostUser.length; i++){
        await addMarker(state.nearbyPostUser[i]);
      }
      update(['googleMap']);
    }
  }

  ///计算地点直线距离
  ///- currentPos 当前GPS位置
  ///- places 地点
  void _computePlacesDistance({
    required Position currentPos,
    required List<PlaceModel> places,
  }) {
    for (var item in places) {
      final location = item.geometry?.location;
      if (location != null) {
        item.distance = Geolocator.distanceBetween(
          currentPos.latitude,
          currentPos.longitude,
          location.lat,
          location.lng,
        );
      }
    }
  }

  void _fetchPlaces(int page) async {
    //清空选中
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state.selectedPlaceRx.value = null;
    });
    final target = state.cameraPositionRx().target;
    state.centerLocation = "${target.longitude},${target.latitude}";
    getNearbyPostUserList();
    final response = await OpenApi.searchNearPlaces(
      latitude: target.latitude,
      longitude: target.longitude,
      radius: 1000,
      language: AppLocalization.instance.locale?.languageCode ?? 'en',
      keyword: state.keywordRx.isNotEmpty ? state.keywordRx() : null,
    );
    if (response.isSuccess) {
      final places = response.data ?? [];
      final currentPos = SS.location.locationRx();
      if (currentPos != null && places.isNotEmpty) {
        _computePlacesDistance(currentPos: currentPos, places: places);
      }

      if(state.keywordRx().isEmpty){
        //定位时，默认选中第一个地点
        state.selectedPlaceRx.value = places.firstOrNull;
      }
      pagingController.setPageData(places);
    } else {
      pagingController.error = '获取数据失败';
    }
  }

  ///搜索
  void onTapSearch(){
    focusNode.unfocus();
    pagingController.refresh();
  }

  void onTapClear(){
    keywordEditingController.clear();
    if(!focusNode.hasFocus){
      pagingController.refresh();
    }
  }

  void onTapPlaceItem(PlaceModel item) async {
    if (item.placeId != state.selectedPlaceRx()?.placeId) {
      state.selectedPlaceRx.value = item;
      final location = item.geometry?.location;
      if (location != null) {
        final zoom = state.cameraPositionRx().zoom;
        final cameraUpdate = CameraUpdate.newLatLngZoom(
          LatLng(location.lat, location.lng),
          zoom,
        );
        _userActionTimer?.cancel();
        _isUserAction = true;
        mapController?.animateCamera(cameraUpdate);
        _userActionTimer =
            Timer(const Duration(seconds: 1), () => _isUserAction = false);
      }
    }
  }

  void onCameraIdle() {
    if (!_isUserAction && state.keywordRx.isEmpty) {
      //搜索周报地点
      pagingController.refresh();
    }
  }

  void onTapConfirm() async {
    final place = state.selectedPlaceRx();
    if (place == null) {
      Loading.showToast('请选择位置');
      return;
    }
    Get.back(result: place);
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}

extension on CameraPosition {
  CameraPosition copyWith({
    LatLng? target,
    double? zoom,
    double? bearing,
    double? tilt,
  }) {
    return CameraPosition(
      target: target ?? this.target,
      zoom: zoom ?? this.zoom,
      bearing: bearing ?? this.bearing,
      tilt: tilt ?? this.tilt,
    );
  }
}