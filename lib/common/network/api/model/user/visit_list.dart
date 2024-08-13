//谁看过我
import '../../api.dart';

class VisitList {
  VisitList({
      this.visitTime, 
      this.userInfo,});

  VisitList.fromJson(dynamic json) {
    visitTime = json['visitTime'];
    userInfo = json['userInfo'] != null ? UserModel.fromJson(json['userInfo']) : null;
  }
  String? visitTime;
  UserModel? userInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['visitTime'] = visitTime;
    if (userInfo != null) {
      map['userInfo'] = userInfo?.toJson();
    }
    return map;
  }

}
