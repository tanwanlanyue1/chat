
import 'package:get/get.dart';
typedef EventBusCallback = void Function(dynamic data);

///事件总线
class EventBus{
  final _listenerMap = <String, List<EventBusCallback>>{};
  static final instance = EventBus._();
  EventBus._();
  factory EventBus() => instance;

  ///监听事件
  ///- name 事件名称
  ///- callback 事件回调
  ///- return 用于取消监听的worker对象
  Worker listen(String name, EventBusCallback callback){
    final list = _listenerMap.putIfAbsent(name, () => [])..add(callback);
    return Worker(() async{
      list.remove(callback);
    }, name);
  }

  ///发送事件到总线
  ///- name 事件名称
  ///- data 数据
  void emit(String name,[dynamic data]){
    final listeners = List<EventBusCallback>.of(_listenerMap[name] ?? <EventBusCallback>[]);
    for(var listener in listeners){
      listener.call(data);
    }
  }

}
