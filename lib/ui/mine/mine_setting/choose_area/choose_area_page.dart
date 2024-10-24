import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/area_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'choose_area_controller.dart';
import 'widget/area_list_tile.dart';

///选择地区
class ChooseAreaPage extends StatelessWidget {

  final List<AreaModel>? list;

  ///选中项
  final List<AreaModel>? selected;

  const ChooseAreaPage({super.key, this.list, this.selected});


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChooseAreaController(list: list, selected: selected),
      global: false,
      builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: Text('选择地区'),
          ),
          body: Padding(
            padding: const FEdgeInsets(top: 1),
            child: PagedListView.separated(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<AreaModel>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return AreaListTile(
                    item: item,
                    onTap: () {
                      controller.onTapItem(item);
                    },
                  );
                },
              ),
              separatorBuilder: (_, index) => const SizedBox(height: 1),
            ),
          ),
        );
      },
    );
  }
}
