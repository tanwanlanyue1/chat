import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';

import 'contract_detail_state.dart';
import 'widget/contract_terminate_dialog.dart';

class ContractDetailController extends GetxController {
  final ContractDetailState state;

  ContractDetailController({required ContractModel contract})
      : state = ContractDetailState(contract);


  ///解除合约
  void terminateContract() async {
    final result = await ContractTerminateDialog.show(state.contractRx());
    if(result == true){
      submitUpdate(3);
    }
  }

  ///- type 类型 1同意签约 2拒绝签约 3解除签约
  void submitUpdate(int type) async{
    Loading.show();
    final response = await UserApi.updateContract(type: type, contractId: state.contractRx().id);
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
      }
      EventBus().emit(kEventContractUpdate);
      Future.delayed(100.milliseconds, () => Get.back(result: true));
    }else{
      response.showErrorMessage();
    }
  }

}
