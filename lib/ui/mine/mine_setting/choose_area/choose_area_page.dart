import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'choose_area_controller.dart';
import 'choose_area_state.dart';
import 'widget/area_list_tile.dart';

///选择地区
class ChooseAreaPage extends StatelessWidget {
  final controller = Get.put(ChooseAreaController());
  final state = Get.find<ChooseAreaController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择地区'),
      ),
      body: Padding(
        padding: const FEdgeInsets(top: 1),
        child: PagedListView.separated(
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate<String>(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              return AreaListTile(
                item: item,
                onTap: () {

                },
              );
            },
          ),
          separatorBuilder: (_, index) => const SizedBox(height: 1),
        ),
      ),
    );
  }
}
