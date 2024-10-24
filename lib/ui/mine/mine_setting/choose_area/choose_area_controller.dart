import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/user/area_model.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'choose_area_state.dart';

class ChooseAreaController extends GetxController {
  final ChooseAreaState state = ChooseAreaState();
  late final pagingController = DefaultPagingController<AreaModel>.single()
    ..addPageRequestListener(fetchPage);

  final List<AreaModel>? list;

  ///选中
  final List<AreaModel>? selected;

  ChooseAreaController({this.list, this.selected});

  void fetchPage(int page) async {
    if (list != null) {
      pagingController.setPageData(list ?? []);
      return;
    }

    final response = await UserApi.getAreaList(level: '0');
    if (response.isSuccess) {
      pagingController.setPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  void onTapItem(AreaModel item) async {
    Loading.show();
    final level = (int.tryParse(item.level) ?? 0) + 1;
    final response =
        await UserApi.getAreaList(level: level.toString(), code: item.code);
    Loading.dismiss();
    if (response.isSuccess) {
      final list = response.data ?? [];
      if (list.isEmpty) {
        //末级
        _onDone(item);
      } else {
        Get.toNamed(
          AppRoutes.chooseAreaPage,
          arguments: {
            'list': list,
            'selected': selected != null ? [...selected!, item] : [item],
          },
          preventDuplicates: false,
        );
      }
    } else {
      response.showErrorMessage();
    }
  }

  void _onDone(AreaModel item) {
    //关闭所有地区选择页
    Get.until((route) => [AppRoutes.accountDataPage, AppRoutes.home].contains(Get.currentRoute));
    final list = (selected ?? [])..add(item);
    //发送事件
    EventBus().emit(kEventChooseArea, list);
  }
}
