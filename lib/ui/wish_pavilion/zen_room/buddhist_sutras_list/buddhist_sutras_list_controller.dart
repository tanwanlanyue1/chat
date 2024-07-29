import 'dart:math';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/httpclient/api_response.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/service/service.dart';

import 'buddhist_sutras_list_state.dart';

class BuddhistSutrasListController extends GetxController {
  final BuddhistSutrasListState state = BuddhistSutrasListState();

  late final pagingController = DefaultPagingController<BuddhistSutrasModel>(
    firstPage: 1,
    pageSize: 30,
    refreshController: RefreshController(),
  )..addPageRequestListener(_fetchPage);

  @override
  void onInit() {
    super.onInit();
    final scriptures = SS.appConfig.configRx()?.scriptures ?? [];
    if(scriptures.isNotEmpty){
      final index = Random().nextInt(scriptures.length);
      state.tipsRx.value = scriptures[index];
    }
  }

  void _fetchPage(int page) async {
    ApiResponse<List<BuddhistSutrasModel>> response;
    final keyword = state.keywordRx().trim();
    if(keyword.isNotEmpty){
      response = await WishPavilionApi.queryBuddhistSutrasList(
        name: keyword,
        type: 0,
        page: page,
        size: pagingController.pageSize,
      );
    }else{
      response = await WishPavilionApi.getBuddhistSutrasList(
        type: 0,
        page: page,
        size: pagingController.pageSize,
      );
    }
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }



}
