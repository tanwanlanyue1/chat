import '../config/tb_websocket_action.dart';
import '../config/tb_websocket_data_parser.dart';

///WebSocket 消息
class TBWebSocketMessage {
  final int? code;

  ///消息类型
  final int? action;

  ///消息类型(枚举)
  TBWebSocketAction? get actionEnum =>
      action != null ? TBWebSocketAction.tryParse(action!) : null;

  ///数据
  final dynamic data;

  ///获取数据model，需要在TBWebSocketDataParser配置解析器
  T? getDataModel<T>() {
    final actionEnum = this.actionEnum;
    if (actionEnum != null) {
      final model = TBWebSocketDataParser.parse(actionEnum, data);
      if (model is T) {
        return model;
      }
    }
    return null;
  }

  ///扩展数据
  final Map<String, dynamic>? _extendedData;

  TBWebSocketMessage({
    this.code,
    this.data,
    Map<String, dynamic>? extendedData,
    int? action,
    TBWebSocketAction? actionEnum,
  })  : _extendedData = extendedData,
        action = actionEnum?.value ?? action;

  factory TBWebSocketMessage.fromJson(Map<String, dynamic> json) {
    final action = json['action'] as int?;
    return TBWebSocketMessage(
      code: json['code'] as int?,
      action: action,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (code != null) {
      json['code'] = code;
    }
    if (action != null) {
      json['action'] = action!;
    }
    if (data != null) {
      json['data'] = data;
    }
    if (_extendedData != null) {
      json.addAll(_extendedData!);
    }
    return json;
  }

  TBWebSocketMessage copyWith({
    int? code,
    int? action,
    dynamic data,
    Map<String, dynamic>? extendedData,
  }) {
    return TBWebSocketMessage(
      code: code ?? this.code,
      action: action ?? this.action,
      data: data ?? this.data,
      extendedData: extendedData ?? _extendedData,
    );
  }
}
