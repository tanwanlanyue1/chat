
///念珠配置
class RosaryBeadsConfigModel {
  RosaryBeadsConfigModel({
    required this.uid,
    required this.backgroundId,
    required this.beadsId,
    required this.sound,
    required this.way,
    required this.direction,
    required this.backgroundImg,
    required this.beadsImg,
  });

  ///用户id
  final int uid;

  ///	场景id(背景)
  final int? backgroundId;

  ///场景id(佛珠款式)
  final int? beadsId;

  ///是否打开声音 0:开启1:关
  final int sound;

  ///念珠方式 0:点击1:滑动
  final int way;

  ///念珠方向 0:中间 1:左 2：右
  final int direction;

  ///场景(背景图片)
  final String backgroundImg;

  ///场景(佛珠款式图片)
  final String beadsImg;

  factory RosaryBeadsConfigModel.fromJson(Map<String, dynamic> json){
    return RosaryBeadsConfigModel(
      uid: json["uid"] ?? 0,
      backgroundId: json["backgroundId"],
      beadsId: json["beadsId"],
      sound: json["sound"] ?? 0,
      way: json["way"] ?? 0,
      direction: json["direction"] ?? 0,
      backgroundImg: json["backgroundImg"] ?? "",
      beadsImg: json["beadsImg"] ?? "",
    );
  }

  RosaryBeadsConfigModel copyWith({
    int? uid,
    int? backgroundId,
    int? beadsId,
    int? sound,
    int? way,
    int? direction,
    String? backgroundImg,
    String? beadsImg,
  }) {
    return RosaryBeadsConfigModel(
      uid: uid ?? this.uid,
      backgroundId: backgroundId ?? this.backgroundId,
      beadsId: beadsId ?? this.beadsId,
      sound: sound ?? this.sound,
      way: way ?? this.way,
      direction: direction ?? this.direction,
      backgroundImg: backgroundImg ?? this.backgroundImg,
      beadsImg: beadsImg ?? this.beadsImg,
    );
  }


  Map<String, dynamic> toJson() => {
    "uid": uid,
    "backgroundId": backgroundId,
    "beadsId": beadsId,
    "sound": sound,
    "way": way,
    "direction": direction,
    "backgroundImg": backgroundImg,
    "beadsImg": beadsImg,
  };


}
