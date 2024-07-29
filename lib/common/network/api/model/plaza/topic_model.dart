
///话题列表-model/专区
class TopicModel {
  TopicModel({
    ///id
    int? id,
    ///用户id
    int? uid,
    /// 标题
    String? title,
    /// 图片
    String? image,
    /// 热度 查看数量
    int? viewNum,
    ///排序
    int? sort,
    ///热门话题：0否1是
    int? hot,}){
    _id = id;
    _uid = uid;
    _title = title;
    _image = image;
    _viewNum = viewNum;
    _sort = sort;
    _hot = hot;
}

  TopicModel.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _title = json['title'];
    _image = json['image'];
    _viewNum = json['viewNum'];
    _sort = json['sort'];
    _hot = json['hot'];
  }
  int? _id;
  int? _uid;
  String? _title;
  String? _image;
  int? _viewNum;
  int? _sort;
  int? _hot;
TopicModel copyWith({
  int? id,
  int? uid,
  String? title,
  String? image,
  int? viewNum,
  int? sort,
  int? hot,
}) => TopicModel(
  id: id ?? _id,
  uid: uid ?? _uid,
  title: title ?? _title,
  image: image ?? _image,
  viewNum: viewNum ?? _viewNum,
  sort: sort ?? _sort,
  hot: hot ?? _hot,
);
  int? get id => _id;
  int? get uid => _uid;
  String? get title => _title;
  String? get image => _image;
  int? get viewNum => _viewNum;
  int? get sort => _sort;
  int? get hot => _hot;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['title'] = _title;
    map['image'] = _image;
    map['viewNum'] = _viewNum;
    map['sort'] = _sort;
    map['hot'] = _hot;
    return map;
  }

}