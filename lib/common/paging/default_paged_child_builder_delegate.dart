import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart'
    show PagedChildBuilderDelegate, PagingController;
import 'package:guanjia/common/paging/default_status_indicators/new_page_error_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/new_page_progress_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';

import 'default_status_indicators/first_page_error_indicator.dart';
import 'default_status_indicators/first_page_progress_indicator.dart';

///分页加载各个状态的子视图显示配置
class DefaultPagedChildBuilderDelegate<ItemType>
    extends PagedChildBuilderDelegate<ItemType> {
  final PagingController pagingController;

  ///分页加载各个状态的子视图显示配置
  ///- pagingController 分页控制器
  ///- itemBuilder 列表项
  ///- firstPageProgressIndicatorBuilder 第1页加载中
  ///- firstPageErrorIndicatorBuilder 第1页加载失败
  ///- noItemsFoundIndicatorBuilder 第一页无数据
  ///- newPageProgressIndicatorBuilder 第n页加载中
  ///- newPageErrorIndicatorBuilder 第n页加载失败
  ///- noMoreItemsIndicatorBuilder 第n页加载无数据
  DefaultPagedChildBuilderDelegate({
    required this.pagingController,
    required super.itemBuilder,
    super.firstPageProgressIndicatorBuilder,
    super.firstPageErrorIndicatorBuilder,
    super.noItemsFoundIndicatorBuilder,
    super.newPageProgressIndicatorBuilder,
    super.newPageErrorIndicatorBuilder,
    super.noMoreItemsIndicatorBuilder,
    super.animateTransitions,
    super.transitionDuration,
  });

  @override
  WidgetBuilder? get firstPageProgressIndicatorBuilder =>
      super.firstPageProgressIndicatorBuilder ??
      (_) => const FirstPageProgressIndicator();

  @override
  WidgetBuilder? get firstPageErrorIndicatorBuilder =>
      super.firstPageErrorIndicatorBuilder ??
      (_) => FirstPageErrorIndicator(
            title: '加载失败',
            onTryAgain: pagingController.retryLastFailedRequest,
          );

  @override
  WidgetBuilder? get noItemsFoundIndicatorBuilder =>
      super.noItemsFoundIndicatorBuilder ?? (_) => const NoItemsFoundIndicator(title: '暂无数据');

  @override
  WidgetBuilder? get newPageProgressIndicatorBuilder =>
      super.newPageProgressIndicatorBuilder ??
      (_) => const NewPageProgressIndicator();

  @override
  WidgetBuilder? get newPageErrorIndicatorBuilder =>
      super.newPageErrorIndicatorBuilder ??
      (_) => NewPageErrorIndicator(
            onTap: pagingController.retryLastFailedRequest,
          );
}
