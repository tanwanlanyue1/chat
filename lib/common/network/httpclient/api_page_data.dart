typedef FromJson<T> = T Function(Map<String, dynamic> json);

///API分页数据
class ApiPageData<ItemType> {
  ///当前页
  final int current;

  ///总页数
  final int pages;

  ///分页数据
  final List<ItemType> records;

  ///分页大小
  final int size;

  ///数据总条数
  final int total;

  ApiPageData({
    required this.current,
    required this.pages,
    required this.records,
    required this.size,
    required this.total,
  });

  ///解析分页数据
  /// - json 响应的json数据
  /// - itemParser 列表项解析
  /// - dataFieldName 列表数据字段名
  /// - pagesFieldName 列表数据总页数字段名
  factory ApiPageData.fromJson(
      Map<String, dynamic>? json, FromJson<ItemType> itemParser, {
        String dataFieldName = 'records',
        String pagesFieldName = 'pages',
      }) {
    json ??= {};
    final records = ((json[dataFieldName] as List?) ?? [])
        .map<ItemType>((e) => itemParser(e))
        .toList();

    return ApiPageData(
      current: json['current'] ?? 0,
      pages: json[pagesFieldName] ?? 0,
      records: records,
      size: json['size'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  ApiPageData<ItemType> copyWith({
    int? current,
    int? pages,
    List<ItemType>? records,
    int? size,
    int? total,
  }) {
    return ApiPageData<ItemType>(
      current: current ?? this.current,
      pages: pages ?? this.pages,
      records: records ?? this.records,
      size: size ?? this.size,
      total: total ?? this.total,
    );
  }
}
