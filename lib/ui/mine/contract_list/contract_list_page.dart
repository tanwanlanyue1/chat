import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/ui/mine/contract_list/widget/contract_list_tile.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'contract_list_controller.dart';

///契约单列表
class ContractListPage extends GetView<ContractListController> {
  const ContractListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.contractList)),
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: PagedListView.separated(
          padding: const FEdgeInsets(top: 1),
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<ContractModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return ContractListTile(
                  model: item,
                  onTap: () {
                    Get.toNamed(AppRoutes.contractDetailPage, arguments: {
                      'status': ContractStatusX.valueOf(item.status),
                    });
                  },
                );
              }),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              color: AppColor.scaffoldBackground,
            );
          },
        ),
      ),
    );
  }
}
