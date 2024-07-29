class AppUpdateVersionModel {
  AppUpdateVersionModel({
    required this.version,
    required this.content,
    required this.flag,
    required this.force,
    required this.link,
  });

  ///	版本号
  final String version;

  ///	更新内容
  final String content;

  ///	更新标志 1商店更新，2链接下载
  final int flag;

  ///	强制更新(0不强制 1强制)
  final int force;

  ///	下载链接
  final String link;

  factory AppUpdateVersionModel.fromJson(Map<String, dynamic> json){
    return AppUpdateVersionModel(
      version: json["version"] ?? "",
      content: json["content"] ?? "",
      flag: json["flag"] ?? 0,
      force: json["force"] ?? 0,
      link: json["link"] ?? "",
    );
  }

}
