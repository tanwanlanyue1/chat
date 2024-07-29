import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/mine/mine_state.dart';
import 'package:guanjia/widgets/app_image.dart';

class MineItem extends StatelessWidget {
  const MineItem({
    super.key,
    required this.items,
    required this.iconLength,
    required this.mainAxisExtent,
    this.onTap,
  });

  final double iconLength;
  final double mainAxisExtent;
  final List<MineItemSource> items;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric( vertical: 12.rpx),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        var item = items[index];
        return GestureDetector(
          onTap: () {
            onTap?.call(index);
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Badge(
                label: Text('${item.number ?? ''}'),
                isLabelVisible: (item.number ?? 0) > 0,
                textColor: Colors.white,
                child: AppImage.asset(
                  '${item.icon}',
                  width: iconLength,
                  height: iconLength,
                ),
              ),
              const Spacer(),
              Text("${item.title}", style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5)),
            ],
          ),
        );
      },
    );
  }
}
