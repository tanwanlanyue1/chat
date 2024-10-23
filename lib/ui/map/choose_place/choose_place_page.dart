import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'choose_place_controller.dart';
import 'choose_place_state.dart';
import 'widget/place_list_tile.dart';

///选择地点
class ChoosePlacePage extends GetView<ChoosePlaceController> {
  final String title;

  const ChoosePlacePage({super.key, this.title = ''});

  ChoosePlaceState get state => controller.state;

  static Future<PlaceModel?> go({String? title}) async {
    final result = await Get.toNamed(
      AppRoutes.choosePlacePage,
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
              text: '确定',
              borderRadius: BorderRadius.circular(4.rpx),
              textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
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
        style: AppTextStyle.fs14m.copyWith(color: AppColor.black3),
        maxLines: 1,
        decoration: InputDecoration(
            hintText: '输入地点（含附近门店/小区/楼宇寻找位置）',
            hintStyle: AppTextStyle.fs14m.copyWith(color: AppColor.black9),
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
      onCameraMove: (pos) {
        state.cameraPositionRx.value = pos;
      },
      onCameraIdle: controller.onCameraIdle,
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
      height: 230.rpx,
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
