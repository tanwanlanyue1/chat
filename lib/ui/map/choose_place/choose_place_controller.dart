import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/app_localization.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_location_content.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'choose_place_state.dart';

class ChoosePlaceController extends GetxController with GetAutoDisposeMixin {
  final ChoosePlaceState state = ChoosePlaceState();

  // 分页控制器
  late final pagingController = DefaultPagingController<PlaceModel>.single()
    ..addPageRequestListener(_fetchPlaces);

  final keywordEditingController = TextEditingController();
  final focusNode = FocusNode();

  GoogleMapController? mapController;

  var _isUserAction = false;
  Timer? _userActionTimer;

  ChoosePlaceController();

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
    final response = await OpenApi.searchNearPlaces(
      latitude: target.latitude,
      longitude: target.longitude,
      radius: 5000,
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
      pagingController.error = S.current.fetchDataError;
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

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
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
        // mapController?.moveCamera(cameraUpdate);
        _userActionTimer =
            Timer(const Duration(seconds: 3), () => _isUserAction = false);
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
      Loading.showToast(S.current.chooseLocation);
      return;
    }
    Get.back(result: place);
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
