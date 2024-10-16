import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/user/vip_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

///VIP套餐
class VipPackageListTile extends StatelessWidget {
  final VipPackageModel item;
  final VoidCallback? onTap;
  final bool isSelected;

  const VipPackageListTile({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 8.rpx;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius + 1),
          gradient: isSelected ? AppColor.horizontalGradient : null,
        ),
        child: Container(
          height: 76.rpx,
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.entriesMonth(item.duration),
                      style: AppTextStyle.fs14m.copyWith(
                        color: AppColor.blackBlue,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              SS.appConfig.currencyUnit,
                              style: AppTextStyle.fs18m.copyWith(
                                color: isSelected
                                    ? AppColor.primaryBlue
                                    : AppColor.blackBlue,
                                height: 1.1,
                              ),
                            ),
                            GradientText(
                              item.discountPrice != 0
                                  ? item.discountPrice.toString()
                                  : item.price.toString(),
                              colors: isSelected
                                  ? const [
                                      AppColor.gradientBegin,
                                      AppColor.gradientEnd,
                                    ]
                                  : const [
                                      AppColor.blackBlue,
                                      AppColor.blackBlue,
                                    ],
                              style: AppTextStyle.fs24m.copyWith(
                                color: isSelected
                                    ? AppColor.primaryBlue
                                    : AppColor.blackBlue,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        if (item.discountPrice != 0)
                          Padding(
                            padding: FEdgeInsets(top: 4.rpx),
                            child: Text(
                              item.price.toCurrencyString(),
                              style: AppTextStyle.fs16m.copyWith(
                                color: AppColor.grayText,
                                height: 1,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (item.discount == 1)
                Container(
                  width: 56.rpx,
                  height: 18.rpx,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                    gradient: AppColor.horizontalGradient,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    S.current.flashSales,
                    style: AppTextStyle.st.size(12.rpx).textColor(Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
