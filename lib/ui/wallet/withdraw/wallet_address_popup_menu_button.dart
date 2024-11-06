import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///钱包地址弹出菜单按钮
class WalletAddressPopupMenuButton extends StatelessWidget {
  final String? address;
  final List<String> addressList;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapAdd;
  final ValueChanged<String>? onTapDelete;

  const WalletAddressPopupMenuButton({
    super.key,
    this.address,
    required this.addressList,
    this.onChanged,
    this.onTapAdd,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopupMenu(context),
      child: Container(
        height: 46.rpx,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.rpx),
          color: AppColor.grayBackground,
        ),
        padding: FEdgeInsets(left: 12.rpx, right: 8.rpx),
        child: Row(
          children: [
            Expanded(
              child: Text(
                address ?? S.current.chooseWalletAddress,
                style: AppTextStyle.fs14.copyWith(
                  color: address == null ? AppColor.black9 : AppColor.black3,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppColor.black9,
              size: 24.rpx,
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final newAddressItem = S.current.addAddress;

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    // 显示上下文菜单
    final result = await showMenu<_PopMenuResult>(
      context: context,
      constraints: BoxConstraints(minWidth: renderBox.size.width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + 46.rpx,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      items: [
        ...addressList.map((item) {
          return _PopupMenuItem(
            text: item,
            isSelected: item == address,
            onTap: (){
              Navigator.maybePop(
                context, _PopMenuResult(item, _PopupMenuAction.tap),
              );
            },
            onTapDelete: (){
              Navigator.maybePop(
                context, _PopMenuResult(item, _PopupMenuAction.delete),
              );
            },
          );
        }),
        _PopupMenuItem(
          text: newAddressItem,
          onTap: () {
            Navigator.maybePop(
              context, _PopMenuResult(newAddressItem, _PopupMenuAction.add),
            );
          },
        ),
      ],
    );

    if(result != null){
      switch(result.action){
        case _PopupMenuAction.tap:
          if(address != result.data){
            onChanged?.call(result.data);
          }
          break;
        case _PopupMenuAction.add:
          onTapAdd?.call();
          break;
        case _PopupMenuAction.delete:
          onTapDelete?.call(result.data);
          break;
      }
    }
  }
  
}


class _PopupMenuItem extends PopupMenuEntry<_PopMenuResult> {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onTapDelete;

  const _PopupMenuItem({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
    this.onTapDelete,
  });

  @override
  State<_PopupMenuItem> createState() => _PopupMenuItemState();

  @override
  double get height => 36.rpx;

  @override
  bool represents(value) => false;
}

class _PopupMenuItemState extends State<_PopupMenuItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 36.rpx,
        margin: FEdgeInsets(horizontal: 8.rpx),
        padding: FEdgeInsets(left: 8.rpx, right: 2.rpx),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: widget.isSelected ? AppColor.primary.withOpacity(0.1) : Colors
              .white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: AppTextStyle.fs12.copyWith(color: AppColor.blackText),
              ),
            ),
            if (widget.onTapDelete != null)
              Button.icon(
                onPressed: widget.onTapDelete,
                padding: FEdgeInsets(all: 8.rpx),
                icon: AppImage.asset(
                  'assets/images/wallet/ic_delete_mini.png',
                  size: 16.rpx,
                ),
              ),
          ],
        ),
      ),
    );
  }

}

enum _PopupMenuAction {
  tap,
  add,
  delete,
}

class _PopMenuResult {
  final String data;
  final _PopupMenuAction action;

  _PopMenuResult(this.data, this.action);
}
