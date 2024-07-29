import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///默认分页控制器
class DefaultPagingController<ItemType> extends PagingController<int, ItemType> {
  ///页大小
  final int pageSize;

  ///下拉刷新控制器
  final RefreshController? _refreshController;

  var _isDisposed = false;

  ///分页控制器
  ///- firstPage 第一页的页码
  ///- pageSize 页大小
  ///- invisibleItemsThreshold 不可见的item数量低于这个阈值时，触发获取下一页
  ///- refreshController 下拉刷新控制器
  DefaultPagingController({
    int firstPage = 1,
    this.pageSize = 20,
    super.invisibleItemsThreshold = 3,
    RefreshController? refreshController,
  })  : _refreshController = refreshController,
        super(firstPageKey: firstPage);

  ///单页控制器
  factory DefaultPagingController.single({RefreshController? refreshController}) => DefaultPagingController(
    pageSize: 0x7fffffffffffffff,
    refreshController: refreshController,
  );

  ///下拉刷新控制器
  RefreshController get refreshController => _refreshController!;

  ///获取数据源数组长度
  int get length => itemList?.length ?? 0;

  ///添加分页数据
  void appendPageData(List<ItemType> newItems) {
    _safeRun((){
      if (_refreshController?.isRefresh == true) {
        final nextPage = newItems.length < pageSize ? null : firstPageKey + 1;
        value = PagingState<int, ItemType>(
          nextPageKey: nextPage,
          error: null,
          itemList: newItems,
        );
        _refreshController?.refreshCompleted();
      } else {
        final nextPage =
        newItems.length < pageSize ? null : (nextPageKey ?? firstPageKey) + 1;
        appendPage(newItems, nextPage);
      }
    });
  }

  ///设置列表数据（没有分页）
  void setPageData(List<ItemType> newItems) {
    _safeRun((){
      value = PagingState<int, ItemType>(
        nextPageKey: null,
        error: null,
        itemList: newItems,
      );
      _refreshController?.refreshCompleted();
    });
  }

  @override
  set error(newError) {
    _safeRun((){
      if (_refreshController?.isRefresh == true) {
        _refreshController?.refreshFailed();
      } else {
        super.error = newError;
      }
    });
  }

  ///通知刷新页数据，获取成功后再刷新到UI上
  void onRefresh() {
    _safeRun(() => notifyPageRequestListeners(firstPageKey));
  }

  @override
  void refresh() {
    _safeRun(super.refresh);
  }

  void _safeRun(VoidCallback runnable){
    if(_isDisposed){
      AppLogger.d('PagingController is disposed!');
    }else{
      runnable.call();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
