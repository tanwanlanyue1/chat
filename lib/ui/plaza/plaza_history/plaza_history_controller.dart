import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/utils/plaza_database.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'plaza_history_state.dart';
import '../../../widgets/hint_show_diglog.dart';

class PlazaHistoryController extends GetxController {
  final PlazaHistoryState state = PlazaHistoryState();
  final pagingController = DefaultPagingController<PlazaListModel>(
    firstPage: 1,
    refreshController: RefreshController(),
  );

  /// 删除记录
  void deleteItem(PlazaListModel item) {
    HintShowDiglog(
      title: "删除历史?",
      contentText: "确定删除该历史记录吗?",
      onConfirm: () {
        PlazaDatabase.deleteDataItem('${item.postId}').then((data) {
          pagingController.itemList?.remove(item);
          update();
        });
      },
    );
  }

  /// 清空历史记录
  void cleanHistory() {
    if (pagingController.itemList?.isEmpty ?? true) {
      return;
    }
    HintShowDiglog(
      title: "",
      contentText: "确定要删除全部历史记录?",
      onConfirm: () {
        PlazaDatabase.deleteDataBaseFile().then((value) {
          pagingController.itemList?.clear();
          update();
        }).catchError((err){
        });
      },
    );
  }

  ///收藏或者取消收藏
  void getCommentCollect(bool collect, int index) async {
    var itemList = List.of(pagingController.itemList!);
    if (collect) {
      itemList[index] = itemList[index].copyWith(
        isCollect: collect,
        collectNum: (itemList[index].collectNum ?? 0) + 1
      );
    } else {
      itemList[index] = itemList[index].copyWith(
          isCollect: collect,
          collectNum: (itemList[index].collectNum ?? 0) - 1
      );
    }
    PlazaDatabase.insertOrUpdateData("${itemList[index].postId}",itemList[index]);
    pagingController.itemList = itemList;
  }

  ///点赞或者取消点赞
  void getCommentLike(bool like, int index) async {
    var itemList = List.of(pagingController.itemList!);
    if (like) {
      itemList[index] = itemList[index].copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) + 1
      );
    } else {
      itemList[index] = itemList[index].copyWith(
          isLike: like,
          likeNum: (itemList[index].likeNum ?? 0) - 1
      );
    }
    PlazaDatabase.insertOrUpdateData("${itemList[index].postId}",itemList[index]);
    pagingController.itemList = itemList;
  }

  /// 获取列表数据
  /// page: 第几页
  void _fetchPage(int page) async {
    final results = await PlazaDatabase.searchAllData(page);

    List<PlazaListModel> list = [];
    for (var element in results) {
      PlazaListModel model = PlazaListModel.fromJson(element);
      model = model.copyWith(
        browsingTime: DateUtil.formatDateStr(
          "${model.browsingTime}",
          format: DateFormats.y_mo_d,
        ),
      );
      list.add(model);
    }
    pagingController.appendPageData(list);
  }

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener(_fetchPage);
  }

}