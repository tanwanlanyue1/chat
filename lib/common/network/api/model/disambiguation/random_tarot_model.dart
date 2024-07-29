//随机塔罗帕
class RandomTarotModel {
  RandomTarotModel({
    //	塔罗牌名称
      this.name,
    //	塔罗牌图片地址
      this.img,
    //	塔罗牌url
      this.url,});

  RandomTarotModel.fromJson(dynamic json) {
    name = json['name'];
    img = json['img'];
    url = json['url'];
  }
  String? name;
  String? img;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['img'] = img;
    map['url'] = url;
    return map;
  }

}