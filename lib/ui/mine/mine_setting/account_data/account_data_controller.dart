import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lunar/lunar.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/photo_and_camera_bottom_sheet.dart';
import 'account_data_state.dart';

class AccountDataController extends GetxController {
  final AccountDataState state = AccountDataState();
  final ImagePicker picker = ImagePicker();

  final loginService = SS.login;

  /// 选择图片或者拍照
  void selectCamera() {
    PhotoAndCameraBottomSheet.show(onUploadUrls: _updateHead, limit: 1, isCrop: true);
  }

  Future<void> selectSex() async {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: const ["男", "女", "保密"],
        onTap: (index) async {
          int gender = 0;
          switch (index) {
            case 0:
              gender = 1;
              break;
            case 1:
              gender = 2;
              break;
          }

          Loading.show();
          final res = await UserApi.modifyUserInfoNoCheck(gender: gender);
          Loading.dismiss();

          if (!res.isSuccess) {
            res.showErrorMessage();
            return;
          }

          Loading.showToast("修改成功");

          loginService.setInfo((val) {
            val?.gender = gender;
          });
        },
      ),
    );
  }

  Future<void> selectBirth(int year, int month, int day) async {
    final date = DateTime(year, month, day);

    final solar = Solar.fromDate(date);
    final lunar = solar.getLunar();

    final birth = solar.toYmd();
    final zodiac = lunar.getYearShengXiao();
    final star = solar.getXingZuo();

    Loading.show();
    final res = await UserApi.modifyUserInfoNoCheck(
      birth: birth,
      zodiac: zodiac,
      star: star,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }

    Loading.showToast("修改成功");

    loginService.setInfo((val) {
      val?.birth = birth;
      val?.zodiac = zodiac;
      val?.star = star;
    });
  }

  void _updateHead(List<String> urls) async {
    Loading.show();
    final infoRes = await UserApi.modifyUserInfo(type: 2, content: urls.first);
    Loading.dismiss();

    if (!infoRes.isSuccess) {
      infoRes.showErrorMessage();
      return;
    }

    Loading.showToast("已提交审核");
  }
}
