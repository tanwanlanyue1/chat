

import 'network/api/api.dart';

///app地址，坐标
class AppPosition {

  ///更新坐标
  static Future<void> updatePosition() async{
    UserApi.updateAccountPosition(
      longitude: '113.383367',
      latitude: '23.24100',
    );
  }

}