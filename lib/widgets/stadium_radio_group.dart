import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

typedef RTextGetter<T> = String Function(T item);

RTextGetter<T> _defaultRTextGetter<T>() {
  return (T item) {
    if (item is String) {
      return item;
    }
    return '$item';
  };
}

///RectRadioGroup
class StadiumRadioGroup<T> extends StatelessWidget {
  final Size _itemSize;
  final List<T> items;
  final T selectedItem;
  final RTextGetter<T> _textGetter;
  final ValueChanged<T>? onChange;

  static Size get _defaultItemSize => Size(60.rpx, 28.rpx);

  StadiumRadioGroup({
    super.key,
    Size? itemSize,
    double? itemSpacing,
    required this.items,
    required this.selectedItem,
    this.onChange,
    RTextGetter<T>? textGetter,
  })  : _itemSize = itemSize ?? _defaultItemSize,
        _textGetter = textGetter ?? _defaultRTextGetter<T>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.rpx),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: Color(0xFFF2F3F7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items
            .map((item) => _buildRadioButton(
                text: _textGetter(item),
                isSelected: item == selectedItem,
                onTap: () {
                  if (item != selectedItem) {
                    onChange?.call(item);
                  }
                }))
            .toList(),
      ),
    );
  }

  Widget _buildRadioButton(
      {required String text, required bool isSelected, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: _itemSize.width,
        height: _itemSize.height,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: isSelected ? Colors.white : null,
        ),
        alignment: Alignment.center,
        child: Text(text,
            style: TextStyle(
              fontSize: 12.rpx,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF8D310F)
                  : const Color(0xFF333333),
            )),
      ),
    );
  }
}
