import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/loading.dart';

import 'contract_generate_state.dart';
import 'widget/contract_edit_dialog.dart';

class ContractGenerateController extends GetxController {
  final ContractGenerateState state = ContractGenerateState();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    Loading.show();
    final responses = await Future.wait<ApiResponse>([
      UserApi.getUnsignedBeautyList(page: 1, size: 100),
      UserApi.getContractTemplate(),
    ]);
    Loading.dismiss();
    if (!responses.every((element) => element.isSuccess)) {
      responses
          .firstWhereOrNull((element) => !element.isSuccess)
          ?.showErrorMessage();
      return;
    }

    final beautyListResp = responses[0] as ApiResponse<List<UserModel>>;
    final templateResp = responses[1] as ApiResponse<ContractModel>;
    state.beautyListRx.value = beautyListResp.data ?? [];
    state.templateRx.value = templateResp.data;
  }

  ///推送契约单给佳丽
  void pushContract() async {
    final selfUser = SS.login.info;
    final beauty = state.selectedBeautyRx();
    final template = state.templateRx();
    if (beauty == null) {
      Loading.showToast(S.current.pleaseSelectFriends);
      return;
    }
    if(template == null){
      Loading.showToast(S.current.contractTemplateEmpty);
      return;
    }

    Loading.show();
    final response = await UserApi.addContract(
      partyAId: selfUser?.uid ?? 0,
      partyAName: selfUser?.nickname ?? '',
      partyBId: beauty.uid,
      partyBName: beauty.nickname,
      content: template.content,
      brokerageService: template.brokerageService,
      brokerageChatting: template.brokerageChatting,
    );
    Loading.dismiss();
    if (response.isSuccess) {
      Loading.showToast(S.current.pushSuccess);
    }else{
      response.showErrorMessage();
    }
  }

  void onTapEditContract() async {
    final template = state.templateRx();
    if(template == null){
      Loading.showToast(S.current.contractTemplateEmpty);
      return;
    }
    final newTemplate = await ContractEditDialog.show(template);
    if(newTemplate != null){
      state.templateRx.value = newTemplate;
    }
  }

}
