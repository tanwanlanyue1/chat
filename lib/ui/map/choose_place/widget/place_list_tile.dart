import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/open/google_places_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class PlaceListTile extends StatelessWidget {
  final PlaceModel item;
  final bool isSelected;
  final VoidCallback? onTap;

  const PlaceListTile({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.rpx,
        color: isSelected ? AppColor.background : null,
        padding: FEdgeInsets(horizontal: 16.rpx),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: FEdgeInsets(bottom: 4.rpx, top: 6.rpx),
              child: buildPlaceName(),
            ),
            buildPlaceAddress(),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceName() {
    return Row(
      children: [
        AppImage.asset(
          isSelected ? 'assets/images/chat/ic_place_selected.png' : 'assets/images/chat/ic_place.png',
          size: 12.rpx,
        ),
        Expanded(
          child: Padding(
            padding: FEdgeInsets(horizontal: 4.rpx),
            child: Text(
              item.name,
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black3,
                height: 1,
              ),
            ),
          ),
        ),
        if(item.distance != null) Text(
          item.distance?.toDistance() ?? '',
          style: AppTextStyle.fs14m.copyWith(
            color: AppColor.black9,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget buildPlaceAddress() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: FEdgeInsets(right: 4.rpx),
            child: Text(
              item.vicinity,
              style: AppTextStyle.fs12m.copyWith(
                color: AppColor.black9,
                height: 1,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.rpx,
          child: isSelected ? AppImage.asset(
            'assets/images/chat/ic_place_checked.png',
            size: 20.rpx,
          ) : null,
        ),
      ],
    );
  }

}

