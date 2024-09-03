

///音视频通话扣费
class ChatCallPayModel {
  ChatCallPayModel({
    required this.uuid,
    required this.duration,
    required this.windows,
  });

  ///UUID
  final String uuid;

  /// 可通话时长(秒)
  final int duration;

  /// 低于第几秒弹出
  final List<int> windows;

  factory ChatCallPayModel.fromJson(Map<String, dynamic> json){
    return ChatCallPayModel(
      uuid: json["uuid"] ?? '',
      duration: json["duration"] ?? 0,
      windows: (json["windows"] as List?)?.cast<int>() ?? <int>[],
    );
  }

}

