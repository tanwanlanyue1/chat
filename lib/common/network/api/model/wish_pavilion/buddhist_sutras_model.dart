
///佛经
class BuddhistSutrasModel {
  BuddhistSutrasModel({
    required this.id,
    required this.name,
    required this.alias,
    required this.type,
    required this.icon,
    required this.audio,
    required this.subtitles,
    required this.remark,
    required this.content,
    required this.duration,
    required this.bless,
  });

  ///ID
  final int id;

  ///经书名
  final String name;

  ///	别名(心经、金刚经...)
  final String alias;

  ///经书类型：0 经书 1 咒语
  final int type;

  ///图标
  final String icon;

  ///音频地址
  final String audio;

  ///字幕文件URL地址
  final String subtitles;

  ///备注
  final String remark;

  ///内容文件URL地址
  final String content;

  ///佛经时长（秒）
  final int duration;

  ///是否收藏 0：未收藏 1：已收藏
  final int bless;

  factory BuddhistSutrasModel.fromJson(Map<String, dynamic> json){
    return BuddhistSutrasModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      alias: json["alias"] ?? "",
      type: json["type"] ?? 0,
      icon: json["icon"] ?? "",
      audio: json["audio"] ?? "",
      subtitles: json["subtitles"] ?? "",
      remark: json["remark"] ?? "",
      content: json["content"] ?? "",
      duration: json["duration"] ?? 0,
      bless: json["bless"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "alias": alias,
    "type": type,
    "icon": icon,
    "audio": audio,
    "subtitles": subtitles,
    "remark": remark,
    "content": content,
    "duration": duration,
    "bless": bless,
  };

}
