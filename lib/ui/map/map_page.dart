import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/map/choose_place/widget/place_list_tile.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'map_controller.dart';
import 'map_state.dart';

///选择地点
class MapPage extends GetView<MapController> {
  final String title;

  const MapPage({super.key, this.title = ''});

  MapState get state => controller.state;

  static Future<PlaceModel?> go({String? title}) async {
    final result = await Get.toNamed(
      AppRoutes.mapPage,
      arguments: {'title': title},
    );
    if(result is PlaceModel){
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: FEdgeInsets(right: 16.rpx),
            child: CommonGradientButton(
              width: 60.rpx,
              height: 32.rpx,
              text: S.current.confirm,
              borderRadius: BorderRadius.circular(4.rpx),
              textStyle: AppTextStyle.fs14.copyWith(color: Colors.white),
              onTap: controller.onTapConfirm,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildMap(),
                buildMarker(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
            ),
            child: Column(
              children: [
                buildSearchBox(),
                buildPlaces(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBox() {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(24.rpx),
    );
    return Padding(
      padding: FEdgeInsets(all: 16.rpx, bottom: 8.rpx),
      child: TextField(
        focusNode: controller.focusNode,
        controller: controller.keywordEditingController,
        style: AppTextStyle.fs14.copyWith(color: AppColor.black3),
        maxLines: 1,
        decoration: InputDecoration(
            hintText: S.current.inputPoiHint,
            hintStyle: AppTextStyle.fs14.copyWith(color: AppColor.black9),
            fillColor: AppColor.background,
            filled: true,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,
            contentPadding: FEdgeInsets(all: 12.rpx),
            suffixIcon: ValueListenableBuilder(
              valueListenable: controller.keywordEditingController,
              builder: (_, value, child) {
                if (value.text.isEmpty) {
                  return Spacing.blank;
                }
                return GestureDetector(
                  onTap: controller.onTapClear,
                  child:
                  Icon(Icons.clear, color: AppColor.black9, size: 18.rpx),
                );
              },
            )),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          controller.onTapSearch();
        },
      ),
    );
  }

  Widget buildMap() {
    return GetBuilder<MapController>(
      id: 'googleMap',
      builder: (_){
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: state.cameraPositionRx(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: false,
          markers: state.markers,
          onMapCreated: (GoogleMapController mapController) {
            controller.mapController = mapController;
          },
          onCameraMove: (pos) {
            state.cameraPositionRx.value = pos;
          },
          onCameraIdle: controller.onCameraIdle,
        );
      },
    );
  }

  Widget buildMarker() {
    return AppImage.asset(
      'assets/images/chat/ic_chat_location.png',
      width: 40.rpx,
    );
  }

  Widget buildPlaces() {
    return Container(
      height: 180.rpx,
      color: Colors.white,
      child: Obx(() {
        final selectedPlace = state.selectedPlaceRx();
        return PagedListView(
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<PlaceModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return PlaceListTile(
                  item: item,
                  onTap: () {
                    controller.onTapPlaceItem(item);
                  },
                  isSelected: selectedPlace?.placeId == item.placeId,
                );
              }),
        );
      }),
    );
  }
}