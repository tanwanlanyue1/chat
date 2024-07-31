import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'contract_generate_controller.dart';
import 'widget/contract_edit_dialog.dart';

///生成契约单
class ContractGeneratePage extends GetView<ContractGenerateController> {
  const ContractGeneratePage({super.key});

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
      child: DropdownMenu(
        width: 343.rpx,
        // menuHeight: 40.rpx,
        initialSelection: null,
        hintText: S.current.selectFriendBinding,
        menuStyle: MenuStyle(
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
          hintStyle: TextStyle(
            fontSize: 14.rpx,
            color: AppColor.gray9,
          ),
          contentPadding: FEdgeInsets(horizontal: 16.rpx),
          constraints: BoxConstraints(maxHeight: 40.rpx),
        ),
        dropdownMenuEntries: List.generate(30, (index) {
          return DropdownMenuEntry<int>(
              value: index,
              label: 'Hello$index',
              style: TextButton.styleFrom(
                foregroundColor: AppColor.gray5,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                fixedSize: Size(double.infinity, 36.rpx),
                padding: FEdgeInsets(horizontal: 16.rpx),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.rpx),
                ),
              ));
        }),
      ),
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
        padding: FEdgeInsets(horizontal: 16.rpx, vertical: 36.rpx),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: AppTextStyle.fs14m.copyWith(
                    color: AppColor.gray5,
                    height: 21 / 14,
                  ),
                  child: Column(
                    children: [
                      //甲已双方
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildRichText(S.current.partyA, '小强'),
                          buildRichText(S.current.partyB, 'Hello1'),
                        ],
                      ),
                      Spacing.h24,
                      Text(
                          '  甲方/乙方双方于今日自愿结成经纪人与艺人系，关系存续期间，甲方负责乙方在管佳APP的约会接单事宜\n\n  乙方在管佳APP上获得的所有收入，将与甲方按照18%的比例分成。'),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: FEdgeInsets(top: 80.rpx),
                        child: buildRichText(
                          S.current.contractDate,
                          DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Button(
              width: 200.rpx,
              onPressed: (){
                ContractEditDialog.show();
              },
              child: Text(S.current.contractEdit),
            ),
            Button(
              margin: FEdgeInsets(top: 24.rpx, bottom: 36.rpx),
              width: 200.rpx,
              onPressed: (){},
              child: Text(S.current.contractPush),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRichText(String text1, String text2) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: text1),
        TextSpan(
            text: text2,
            style: AppTextStyle.fs14m.copyWith(
              color: AppColor.gray30,
            )),
      ],
    ));
  }
}
