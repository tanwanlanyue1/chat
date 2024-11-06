import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

///VIP套餐
class VipPackageListTile extends StatelessWidget {
  final VipPackageModel item;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDialog;

  const VipPackageListTile({
    super.key,
    required this.item,
    this.isSelected = false,
    this.showDialog = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          buildBackground(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: item.nameplate,
                  height: 20.rpx,
                ),
                Padding(
                  padding: FEdgeInsets(top: 16.rpx),
                  child: ForegroundGradientMask(
                    isMask: isSelected,
                    gradient: LinearGradient(
                      colors: AppColor.horizontalGradient.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: Text(
                      item.durationText,
                      style: AppTextStyle.fs12.copyWith(
                        color: isSelected ? Colors.white : AppColor.grayText,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: FEdgeInsets(top: 8.rpx),
                  child: ForegroundGradientMask(
                    gradient: LinearGradient(
                      colors: AppColor.horizontalGradient.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: FEdgeInsets(bottom: 2.rpx),
                          child: Text(
                            SS.appConfig.currencyUnit,
                            style: AppTextStyle.fs12.copyWith(
                              color: AppColor.black3,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Text(
                          item.discountPrice != 0
                              ? item.discountPrice.toString()
                              : item.price.toString(),
                          style: AppTextStyle.fs24m.copyWith(
                            color: AppColor.black3,
                            height: 1.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (item.discountPrice != 0)
                  Padding(
                    padding: FEdgeInsets(top: 4.rpx),
                    child: Text(
                      S.current.originalPrice(item.price.toCurrencyString()),
                      style: AppTextStyle.fs10.copyWith(
                        color: AppColor.grayText,
                        height: 1,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if ((item.discount == 1) && !showDialog)
            Positioned(
              top: 0,
              left: 0,
              child: buildDiscountFlag(),
            ),
        ],
      ),
    );
  }

  Widget buildDiscountFlag() {
    return Container(
      padding: FEdgeInsets(horizontal: 4.rpx, vertical: 3.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.rpx),
          topRight: Radius.circular(4.rpx),
          bottomRight: Radius.circular(4.rpx),
        ),
        gradient: LinearGradient(
          colors: AppColor.horizontalGradient.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(S.current.flashSales,
          style: AppTextStyle.fs10.copyWith(
            color: Colors.white,
            height: 1,
          )),
    );
  }

  Widget buildBackground({required Widget child}) {
    final radius = 8.rpx;
    final colors = AppColor.horizontalGradient.colors;

    return Container(
      width: 92.rpx,
      height: 120.rpx,
      margin: FEdgeInsets(top: 8.rpx),
      padding: const FEdgeInsets(all: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: isSelected
            ? LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : AppColor.black999.withOpacity(0.2),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius - 1),
        ),
        child: Container(
          padding: FEdgeInsets(top: showDialog ? 8.rpx : 16.rpx),
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(radius - 1),
                  gradient: LinearGradient(
                    colors: colors.map((e) => e.withOpacity(0.1)).toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ))
              : null,
          child: child,
        ),
      ),
    );
  }
}
