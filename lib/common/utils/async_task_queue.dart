
import 'app_logger.dart';

///异步任务队列
class AsyncTaskQueue{

  final _tasks = <Future>[];
  Future? _current;

  var i = 0;
  void add(Future task){
    _tasks.add(task);
    _execute();
  }

  void clear(){
    _tasks.clear();
  }

  Future<void> _execute() async{
    if (_current == null && _tasks.isNotEmpty) {
      // print('_execute: ${i++}');
      _current = _tasks.removeAt(0);
      try {
        await _current;
      } catch (ex) {
        AppLogger.w('AsyncTaskQueue发生异常，ex=$ex');
      }
      _current = null;
      if (_tasks.isNotEmpty) {
        await _execute();
      }
    }
  }


}