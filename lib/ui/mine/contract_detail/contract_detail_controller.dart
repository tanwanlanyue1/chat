import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import 'contract_detail_state.dart';
import 'widget/contract_terminate_dialog.dart';

class ContractDetailController extends GetxController with GetAutoDisposeMixin {
  final ContractDetailState state;
  final int contractId;

  ContractDetailController({required this.contractId})
      : state = ContractDetailState();

  ///当前用户是否是代理
  bool get isSelfAgent => state.contractRx()?.partyAId == SS.login.userId;

  @override
  void onInit() {
    super.onInit();
    //契约状态变更监听
    autoCancel(SS.inAppMessage.listen((message) {
      final content = message.contractUpdateContent;
      if(content?.contractId == contractId){
        fetchData();
      }
    }));
    fetchData();
  }

  Future<ContractModel?> fetchData() async{
    Loading.show();
    final response = await UserApi.getContract(contractId);
    Loading.dismiss();
    if(response.isSuccess){
      state.contractRx.value = response.data;
    }else{
      response.showErrorMessage();
    }
    return response.data;
  }

  ///解除合约
  void terminateContract() async {
    var contract = state.contractRx() ?? await fetchData();
    if(contract == null){
      Loading.showToast('解除失败');
      return;
    }

    final result = await ContractTerminateDialog.show(
      contract: contract,
      isAgent: isSelfAgent,
    );
    if(result == true){
      submitUpdate(isSelfAgent ? 3 : 4);
    }
  }

  ///- type 	类型 1同意签约 2拒绝签约 3解除签约 4佳丽申请解约 5经纪人拒绝
  void submitUpdate(int type) async{
    Loading.show();
    final response = await UserApi.updateContract(type: type, contractId: contractId);
    Loading.dismiss();
    if(response.isSuccess){
      switch(type){
        case 1:
          Loading.showToast('签约成功');
          break;
        case 2:
          //nothing
          break;
        case 3:
          Loading.showToast('解除成功');
          break;
        case 4:
          Loading.showToast('申请解约成功');
          break;
      }
      EventBus().emit(kEventContractUpdate);
      Future.delayed(100.milliseconds, () => Get.back(result: true));
    }else{
      response.showErrorMessage();
    }
  }

}
