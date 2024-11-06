import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/record/wallet_record_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///钱包记录筛选对话框
class WalletRecordFilterDialog extends StatefulWidget {
  ///选中数据
  final RecordFilterData? selectedData;
  final List<RecordType> items;

  const WalletRecordFilterDialog._({
    super.key,
    required this.items,
    this.selectedData,
  });

  static Future<RecordFilterData?> show({
    required List<RecordType> items,
    RecordFilterData? data,
  }) {
    return Get.bottomSheet(
        WalletRecordFilterDialog._(
          items: items,
          selectedData: data,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
        ));
  }

  @override
  State<WalletRecordFilterDialog> createState() =>
      _WalletRecordFilterDialogState();
}

class _WalletRecordFilterDialogState extends State<WalletRecordFilterDialog> {
  
  ///选中数据
  var filterData = RecordFilterData(types: []);

  @override
  void initState() {
    super.initState();
    if(widget.selectedData != null){
      filterData = widget.selectedData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDateRange(),
        Padding(
          padding: FEdgeInsets(all: 16.rpx),
          child: Text(
            S.current.quickFilter,
            style: AppTextStyle.fs16m.copyWith(
              color: AppColor.blackBlue,
              height: 1.0,
            ),
          ),
        ),
        buildGridView(),
        buildButtons(),
      ],
    );
  }

  Widget buildDateRange() {
    Widget buildItem({
      required String hintText,
      final DateTime? dateTime,
      VoidCallback? onTap,
    }) {
      final dateText =
          dateTime?.let((it) => DateUtil.formatDate(it, format: S.current.yyyyM));
      final isSelected = dateText != null;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 140.rpx,
          height: 32.rpx,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            color: isSelected
                ? AppColor.primaryBlue.withOpacity(0.1)
                : AppColor.background,
            border: Border.all(
              color: isSelected ? AppColor.primaryBlue : AppColor.background,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            dateText ?? hintText,
            style: AppTextStyle.fs14.copyWith(
              color: isSelected ? AppColor.primaryBlue : AppColor.grayText,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: FEdgeInsets(left: 16.rpx, top: 16.rpx),
          child: Row(
            children: [
              buildItem(
                  hintText: S.current.beginTime,
                  dateTime: filterData.beginTime,
                  onTap: () {
                    showDatePicker(filterData.beginTime, onConfirm: (date) {
                      setState(() {
                        filterData = filterData.copyWith(beginTime: date);
                      });
                    });
                  }),
              Container(
                width: 6.rpx,
                height: 1,
                color: AppColor.grayText,
                margin: FEdgeInsets(horizontal: 4.rpx),
              ),
              buildItem(
                  hintText: S.current.stopTime,
                  dateTime: filterData.endTime,
                  onTap: () {
                    showDatePicker(filterData.endTime, onConfirm: (date) {
                      setState(() {
                        filterData = filterData.copyWith(endTime: date);
                      });
                    });
                  }),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: Get.back,
            icon: AppImage.asset(
              'assets/images/common/close.png',
              width: 24.rpx,
              height: 24.rpx,
            ),
          ),
        )
      ],
    );
  }

  void onTapRecordTypeItem(RecordType item){
    final types = filterData.types;
    final type = types.firstWhereOrNull((element) => element.value == item.value);
    if(type != null){
      types.remove(type);
    }else{
      if(item.isALl){
        //取消其他选项
        types..clear()..add(item);
      }else{
        //取消选中全部
        types..removeWhere((element) => element.isALl)..add(item);
      }
    }
    setState(() {
    });
  }

  Widget buildGridView() {
    return GridView.count(
      padding: FEdgeInsets(horizontal: 16.rpx),
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 108 / 32,
      mainAxisSpacing: 12.rpx,
      crossAxisSpacing: 8.rpx,
      children: widget.items.map((item) {
        final isSelected  = filterData.types.containsWith((e) => e.value == item.value);
        return GestureDetector(
          onTap: () => onTapRecordTypeItem(item),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              color: isSelected ? AppColor.primaryBlue : AppColor.background,
            ),
            alignment: Alignment.center,
            child: Text(
              item.label,
              style: AppTextStyle.fs12.copyWith(
                color: isSelected ? Colors.white : AppColor.black3,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: FEdgeInsets(top: 24.rpx, bottom: 24.rpx + Get.padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(
            width: 120.rpx,
            height: 48.rpx,
            backgroundColor: AppColor.black9,
            onPressed: Get.back,
            child: Text(S.current.cancel, style: AppTextStyle.fs14.copyWith(),),
          ),
          CommonGradientButton(
            width: 120.rpx,
            height: 48.rpx,
            text: S.current.confirm,
            textStyle: AppTextStyle.fs14.copyWith(color: Colors.white),
            onTap: (){
              final beginTime = filterData.beginTime;
              final endTime = filterData.endTime;
              if(beginTime != null && endTime != null && beginTime.isAfter(endTime)){
                Loading.showToast(S.current.beginTimeHint);
                return;
              }
              Get.back(result: filterData);
            },
          )
        ],
      ),
    );
  }

  ///日期选择
  void showDatePicker(DateTime? dateTime, {ValueChanged<DateTime>? onConfirm}) {
    Pickers.showDatePicker(context,
        mode: DateMode.YM,
        selectDate: dateTime?.let(PDuration.parse),
        pickerStyle: PickerStyle(
          headDecoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
            color: Colors.white,
          ),
          cancelButton: Padding(
            padding: FEdgeInsets(horizontal: 12.rpx, top: 8.rpx),
            child: Text(
              S.current.cancel,
              style: AppTextStyle.fs14m.copyWith(color: AppColor.black9),
            ),
          ),
          commitButton: Padding(
            padding: FEdgeInsets(horizontal: 12.rpx, top: 8.rpx),
            child: Text(
              S.current.confirm,
              style: AppTextStyle.fs14m.copyWith(color: AppColor.blackBlue),
            ),
          ),
        ), onConfirm: (value) {
      final year = value.year;
      final month = value.month;
      if (year != null && month != null) {
        onConfirm?.call(DateTime(year, month));
      }
    });
  }
}

///选中的筛选数据
class RecordFilterData {
  final List<RecordType> types;
  final DateTime? beginTime;
  final DateTime? endTime;

  RecordFilterData({required this.types, this.beginTime, this.endTime});

  RecordFilterData copyWith({DateTime? beginTime, DateTime? endTime}) {
    return RecordFilterData(
      types: types,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
