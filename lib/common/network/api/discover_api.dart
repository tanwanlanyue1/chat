import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/network.dart';

import 'model/discover/discover_model.dart';

/// 发现接口API
class DiscoverApi {
  const DiscoverApi._();

  /// 发布邀约
  /// type: 约会类型 1边玩边吃 2同城周边 3双飞国外 4海上邮轮 5自驾游 6商务陪游 7饭局宴席
  /// content: 约会内容介绍
  /// coordinate: 经纬度
  /// location: 约会地点
  /// startTime: 约会开始时间
  /// endTime: 约会结束时间
  /// tag: 附加标签
  /// serviceCharge: 服务费 0表示没有服务费
  static Future<ApiResponse> appointmentAdd({
    required int type,
    required String content,
    required String coordinate,
    required String location,
    required String startTime,
    required String endTime,
    required String tag,
    required double serviceCharge,
  }) {
    return HttpClient.post(
      '/api/Appointment/add',
      data: {
        "type": type,
        "content": content,
        "coordinate": coordinate,
        "location": location,
        "startTime": startTime,
        "endTime": endTime,
        "tag": tag,
        "serviceCharge": serviceCharge,
      },
    );
  }

  /// 获取约会列表
  /// type: 约会类型 1边玩边吃 2同城周边 3双飞国外 4海上邮轮 5自驾游 6商务陪游 7饭局宴席
  /// subType: 约会子类型 1最新 2限女士 3有服务费 4个人用户
  /// coordinate: 经纬度
  static Future<ApiResponse<List<AppointmentModel>>> appointmentList({
    int? type,
    required int subType,
    required String coordinate,
    int page = 1,
    int size = 10,
  }) {
    return HttpClient.get(
      '/api/Appointment/list',
      params: {
        "type": type,
        "coordinate": coordinate,
        "subType": subType,
        "page": page,
        "size": size,
      },
      dataConverter: (data) {
        if (data is List) {
          return data.map((e) => AppointmentModel.fromJson(e)).toList();
        }
        return [];
      }
    );
  }

  /// 获取自己的邀约
  static Future<ApiResponse<AppointmentModel>> getOneself() {
    return HttpClient.get(
        '/api/Appointment/getOneself',
        dataConverter: (data) => AppointmentModel.fromJson(data ?? {})
    );
  }

  /// 删除邀约
  /// id 约会id
  static Future<ApiResponse> delAppointment({
    required int id
}) {
    return HttpClient.post(
      '/api/Appointment/del',
      data: {
         "id":id
      },
      dataConverter: (data) => data,
    );
  }
}