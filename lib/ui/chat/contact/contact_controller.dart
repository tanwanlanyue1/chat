import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paging_controller.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'contact_state.dart';

class ContactController extends GetxController with GetAutoDisposeMixin {
  final ContactState state = ContactState();
  final editingController = TextEditingController();

  //分页控制器
  late final pagingController = DefaultPagingController<UserModel>(
    pageSize: 20,
    refreshController: RefreshController(),
  )..addPageRequestListener(fetchPage);

  @override
  void onInit() {
    super.onInit();
    autoDisposeWorker(EventBus().listen(kEventIsAttention, (data) {
      pagingController.refresh();
    }));
  }

  void fetchPage(int page) async {
    final response = await UserApi.attentionOrFansList(
      type: 0,
      page: page,
      size: pagingController.pageSize,
    );
    if (response.isSuccess) {
      pagingController.appendPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

  void doSearch() async {
    final text = editingController.text.trim();
    if (text.isEmpty) {
      return;
    }
    final chatNo = int.tryParse(text);
    if (chatNo == null) {
      Loading.showToast(S.current.invalidUserId);
      return;
    }

    Loading.show();
    final response = await UserApi.queryUserByChatNo(chatNo);
    Loading.dismiss();
    if (response.isSuccess) {
      final userId = response.data?.uid;
      if (userId != null) {
        CommonUtils.hideSoftKeyboard();
        Get.toNamed(AppRoutes.userCenterPage, arguments: {
          'userId': userId,
        });
      } else {
        Loading.showToast(S.current.userNotFound);
      }
    } else {
      response.showErrorMessage();
    }
  }

}
