import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

import 'contract_detail_state.dart';
import 'widget/contract_terminate_dialog.dart';

class ContractDetailController extends GetxController {
  final ContractDetailState state;

  ContractDetailController({required ContractStatus status})
      : state = ContractDetailState(status);


  ///解除合约
  void terminateContract(){
    ContractTerminateDialog.show();
  }

}
