import 'dart:math';

///迭代器扩展
extension IterableExtension<T> on Iterable<T>{

  ///列表转map
  Map<K,V> toMap<K,V>(MapEntry<K,V> Function(T item) mapper){
    final map = <K,V>{};
    forEach((element) {
      final entry = mapper(element);
      map[entry.key] = entry.value;
    });
    return map;
  }

  ///列表转map
  Map<K,V> toIndexedMap<K,V>(MapEntry<K,V> Function(int index, T item) mapper){
    final map = <K,V>{};
    var i = 0;
    forEach((element) {
      final entry = mapper(i++, element);
      map[entry.key] = entry.value;
    });
    return map;
  }


  ///在每两个列表项中间插入separator
  Iterable<T> separated(T separator) {
    final iterator = this.iterator;

    if (!iterator.moveNext()) return const [];

    final buffer = <T>[];

    buffer.add(iterator.current);

    while (iterator.moveNext()) {
      buffer
        ..add(separator)
        ..add(iterator.current);
    }

    return buffer;
  }

  ///判断列表是否包含某一项
  bool containsWith(bool Function(T element) test){
    for(var item in this){
      if(test(item)){
        return true;
      }
    }
    return false;
  }

}

///列表扩展
extension TBListExtension<T> on List<T>{

  ///通过index安全获取列表项，如果index不在范围内返回null
  T? tryGet(int index){
    if(index >= 0 && index <= length -1){
      return this[index];
    }
    return null;
  }
}

///Map扩展
extension TBMapExtension<K,V> on Map<K, V> {

  String toQueryString(){
    var text = '';
    forEach((key, value) {
      if(value != null){
        text+= '&$key=$value';
      }
    });
    if(text.isNotEmpty){
      text = text.substring(1);
    }
    return text;
  }

  int getInt(String key, {int defaultValue = 0}) {
    return getIntOrNull(key) ?? defaultValue;
  }

  int? getIntOrNull(String key) {
    if (this[key] != null) {
      return int.tryParse(this[key].toString());
    }
    return null;
  }

  double getDouble(String key, {double defaultValue = 0}) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  double? getDoubleOrNull(String key) {
    if (this[key] != null) {
      return double.tryParse(this[key].toString());
    }
    return null;
  }

  bool? getBoolOrNull(String key) {
    if (this[key] != null) {
      return bool.tryParse(this[key].toString());
    }
    return null;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  String getString(String key, {String defaultValue = ''}) {
    return getStringOrNull(key) ?? defaultValue;
  }

  String? getStringOrNull(String key) {
    if (this[key] is String) {
      return this[key].toString();
    }
    return null;
  }

  void put(K key, V value){
    this[key] = value;
  }
}

extension TBIntListExtension on List<int>{
  ///与other的每一个值相加返回新的列表
  List<int> addition(List<int> other){
    return List.generate(max(length, other.length), (index){
      return (tryGet(index) ?? 0) + (other.tryGet(index) ?? 0);
    });
  }
}