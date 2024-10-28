import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'contract_generate_controller.dart';
import 'contract_generate_state.dart';
import 'widget/contract_view.dart';

///生成契约单
class ContractGeneratePage extends GetView<ContractGenerateController> {
  const ContractGeneratePage({super.key});


  ContractGenerateState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.generateContract),
      ),
      body: Stack(
        children: [
          buildBackground(),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.gradientBackgroundBegin,
              AppColor.gradientBackgroundEnd,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Positioned.fill(
      child: Column(
        children: [
          buildDropdownButton(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildDropdownButton() {
    return Padding(
      padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
      child: Obx((){
        final beautyList = state.beautyListRx();
        final selectedBeauty = state.selectedBeautyRx();
        return DropdownMenu(
          width: 343.rpx,
          // menuHeight: 40.rpx,
          initialSelection: selectedBeauty,
          onSelected: (value){
            state.selectedBeautyRx(value);
          },
          hintText: S.current.selectFriendBinding,
          textStyle: AppTextStyle.fs12m.copyWith(color: AppColor.blackBlue),
          menuStyle: MenuStyle(
            elevation: MaterialStateProperty.all(1),
            alignment: const Alignment(-1.0, 1.4),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.rpx),
              ),
            ),
            padding: MaterialStateProperty.all(FEdgeInsets(all: 16.rpx)),
            maximumSize: MaterialStateProperty.all(
              Size(Get.width, Get.height * 0.6),
            ),
          ),
          trailingIcon: Icon(Icons.arrow_drop_down, size: 24.rpx),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20.rpx),
              gapPadding: 0,
            ),
            isDense: true,
            hintStyle: AppTextStyle.fs12m.copyWith(
              color: AppColor.black666,
            ),
            contentPadding: FEdgeInsets(horizontal: 16.rpx),
            constraints: BoxConstraints(maxHeight: 40.rpx),
          ),
          dropdownMenuEntries: beautyList.map((item){
            return DropdownMenuEntry<UserModel>(
                value: item,
                label: item.nickname,
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.blackBlue,
                  textStyle: AppTextStyle.fs14m,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  fixedSize: Size(double.infinity, 36.rpx),
                  padding: FEdgeInsets(horizontal: 16.rpx),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                ));
          }).toList(growable: false),
        );
      }),
    );
  }

  Widget buildContent() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.rpx),
          ),
        ),
        padding: FEdgeInsets(horizontal: 28.rpx, top: 36.rpx, bottom: Get.padding.bottom),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx((){
                  final beauty = state.selectedBeautyRx();
                  final template = state.templateRx();
                  return ContractView(
                    partyA: SS.login.info?.nickname ?? '',
                    partyB: beauty?.nickname ?? '',
                    content: template?.fullContent ?? '',
                    date: DateTime.now().formatYMD,
                  );
                }),
              ),
            ),
            Button.stadium(
              width: 146.rpx,
              height: 36.rpx,
              onPressed: controller.onTapEditContract,
              child: Text(S.current.contractEdit, style: AppTextStyle.fs14),
            ),
            Button.stadium(
              width: 146.rpx,
              height: 36.rpx,
              margin: FEdgeInsets(vertical: 36.rpx),
              onPressed: controller.pushContract,
              child: Text(S.current.contractPush, style: AppTextStyle.fs14),
            ),
          ],
        ),
      ),
    );
  }

}
