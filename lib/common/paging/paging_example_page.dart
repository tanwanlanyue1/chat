import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/network/network.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/app_logger.dart';

import 'default_paging_controller.dart';

///分页加载 + 下拉刷新 示例
class PagingExamplePage extends StatefulWidget {
  const PagingExamplePage({super.key});

  @override
  State<PagingExamplePage> createState() => _PagingExamplePageState();
}

class _PagingExamplePageState extends State<PagingExamplePage> {
  final pagingController = DefaultPagingController<String>(
    firstPage: 1,
    pageSize: 30,
    refreshController: RefreshController(),
  );

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(fetchPage);
  }

  void fetchPage(int page) async {
    AppLogger.d('fetchPage: $page');

    MockApi.errorPage = 3;
    final response =
        await MockApi.fetcPage(page: page, pageSize: pagingController.pageSize);
    if (response.isSuccess) {
      final items = response.data ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分页加载+下拉刷新 示例'),
      ),
      body: SmartRefresher(
        controller: pagingController.refreshController,
        onRefresh: pagingController.onRefresh,
        child: PagedListView(
          pagingController: pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<String>(
            pagingController: pagingController,
            itemBuilder: (_, item, index) {
              return ListTile(title: Text(item));
            },
          ),
        ),
      ),
    );
  }
}

class MockApi {
  static var page = 0;
  static var errorPage = 0;
  static var emptyPage = 0;

  static Future<ApiResponse<List<String>>> fetcPage(
      {required int page, required int pageSize}) async {
    await Future.delayed(Duration(seconds: 1));
    if (page == errorPage) {
      return ApiResponse.error(AppException(-1, 'error'));
    }
    if (page == emptyPage) {
      return ApiResponse.success([]);
    }
    final data = List.generate(
        pageSize, (index) => ((page - 1) * pageSize + index + 1).toString());
    return ApiResponse.success(data);
  }
}
