import 'dart:convert';

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_my_team_state.dart';
import 'widget/team_contract_terminate_dialog.dart';

class MineMyTeamController extends GetxController {
  final MineMyTeamState state = MineMyTeamState();

  //分页控制器
  final pagingController = DefaultPagingController<TeamUser>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  @override
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  void _fetchPage(int page) async {
    final res = await UserApi.getTeamUserList(
      page: page,
      size: pagingController.pageSize,
    );

    final list = res.data ?? [];
    if (res.isSuccess) {
      pagingController.appendPageData(list);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  ///查询详情
  ///detail：查看详情
  void getContract(int id,{bool? detail,int? index}) async {
    final response = await UserApi.getContract(id);
    if(response.isSuccess){
      if(detail ?? false){
        Get.toNamed(AppRoutes.contractDetailPage, arguments: {
          'contractId': id,
        });
      }else{
        state.currentIndex = index!;
        terminateContract(response.data!);
      }
    }
  }

  ///解除合约
  void terminateContract(ContractModel contract) async {
    final result = await TeamContractTerminateDialog.show(
      contract: contract,
    );

    if(result != null){
      submitUpdate(result == 1 ? 3 : 5, contract.id);
    }
  }

  ///- type 	类型 1同意签约 2拒绝签约 3解除签约 4佳丽申请解约 5经纪人拒绝
  void submitUpdate(int type,int id) async{
    Loading.show();
    final response = await UserApi.updateContract(type: type, contractId: id);
    Loading.dismiss();
    if(response.isSuccess){
      switch(type){
        case 1:
          Loading.showToast('签约成功');
          break;
        case 2:
          break;
        case 3:
          Loading.showToast('解除成功');
          break;
        case 4:
          Loading.showToast('申请解约成功');
          break;
      }
      final itemList = List.of(pagingController.itemList!);
      itemList[state.currentIndex] = itemList[state.currentIndex].copyWith(
          remark: "normal"
      );
      print("itemList===${jsonEncode(itemList)}");
      pagingController.itemList = itemList;
    }else{
      response.showErrorMessage();
    }
  }

}
