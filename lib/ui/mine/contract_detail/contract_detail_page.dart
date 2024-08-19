import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_generate/widget/contract_view.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'contract_detail_controller.dart';
import 'contract_detail_state.dart';

///契约详情
class ContractDetailPage extends GetView<ContractDetailController> {
  const ContractDetailPage({super.key});

  ContractDetailState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(state.titleRx)),
      ),
      body: SingleChildScrollView(
        padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            color: Colors.white,
          ),
          padding: FEdgeInsets(horizontal: 12.rpx, vertical: 36.rpx),
          child: Obx((){
            final contract = state.contractRx();
            final status = state.statusRx;
            if(contract == null){
              return Spacing.blank;
            }
            return Column(
              children: [
                ContractView(
                  partyA: contract.partyAName,
                  partyB: contract.partyBName,
                  content: contract.fullContent,
                  date: contract.createTime,
                ),
                buildButtons(status),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget buildButtons(ContractStatus? status) {
    final children = <Widget>[];
    switch (status) {
      case ContractStatus.signing:
        children.addAll([
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: () => controller.submitUpdate(2),
            backgroundColor: AppColor.gray9,
            child: Text(S.current.contractReject),
          ),
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: () => controller.submitUpdate(1),
            child: Text(S.current.contractSignNow),
          ),
        ]);
        break;
      // case ContractStatus.signing:
      //   children.add(Text(S.current.contractSigning));
      //   break;
      case ContractStatus.signed:
        children.add(
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: controller.terminateContract,
            backgroundColor: AppColor.gray9,
            child: Text(S.current.contractTerminateNow),
          ),
        );
        break;
      case ContractStatus.terminated:
        children.add(Text(S.current.contractTerminated));
        break;
      default:
        break;
    }

    return Padding(
      padding: FEdgeInsets(horizontal: 12.rpx, top: 80.rpx),
      child: Row(
        mainAxisAlignment: children.length > 1
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
