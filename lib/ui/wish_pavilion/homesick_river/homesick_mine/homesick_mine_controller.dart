
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/loading.dart';

import '../widget/homesick_bottom_sheet.dart';
import 'homesick_mine_state.dart';
import 'widget/fulfill_show_diglog.dart';

class HomesickMineController extends GetxController {
  final HomesickMineState state = HomesickMineState();

  final pagingController = DefaultPagingController<RecordLightModel>(
    firstPage: 1,
    pageSize: 10,
    refreshController: RefreshController(),
  );

  /// 完愿
  Future<void> fulfillOneWish(RecordLightModel? item) async {
    final response = await HomesickRiverApi.getRecordById(
      id: item!.recordId!,
    );
    if(response.isSuccess){
      DateTime now = DateTime.now();
      DateTime endTime = DateUtil.getDateTime(item.endTime!)!;
      int comparison = now.compareTo(endTime);
      if(response.data?.gift?.goldNum == 0 && comparison < 0){
        Loading.showToast("免费天灯不可提前完愿！");
      }else{
        FulfillShowDiglog(
            title: "确定完愿?",
            item: response.data,
            callBack: (){
              updateRecord(item: item);
            }
        );
      }
    }else{
      response.showErrorMessage();
    }
  }

  ///获取记录详情
  Future<void> getRecordById({required RecordLightModel item}) async {
    Loading.show();
    final response = await HomesickRiverApi.getRecordById(
      id: item.recordId!,
    );
    Loading.dismiss();
    if(response.isSuccess){
      state.recordDetail = response.data ?? RecordDetailsModel.fromJson({});
      HomesickBottomSheet.show(
          item: state.recordDetail,
          self: true,
          sky: state.recordDetail.gift?.type == 3,
          callback: (){
            updateRecord(item: item).then((value) => {
              if(value == true){
                Get.back()
              }
            });
          },
          benediction: (){
              item.bless = item.bless! + 1;
              update();
          }
      );
    }
  }

  /// 获取列表数据
  /// page: 第几页
  /// type：灯类型 3:河灯 4：天灯
  void _fetchPage(int page,) async {
    final response = await HomesickRiverApi.getRecordList(
      page: page,
      isAll: 0,
      type: state.mineBottom[state.mineType]['type'],
    );
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  @override
  void onInit() {
    
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  ///修改灯的状态
  ///recordId:	放灯记录ID
  Future<bool?> updateRecord({required RecordLightModel item}) async {
    final response = await HomesickRiverApi.updateRecord(
      recordId: item.recordId!,
    );
    if(response.isSuccess){
      if(item.status == 0){
        item.status = 1;
      }else{
        item.status = 0;
      }
      update();
      if(item.type == 4){
        Get.back();
      }
      return true;
    }
  }

}
