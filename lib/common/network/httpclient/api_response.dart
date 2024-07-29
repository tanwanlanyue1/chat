
import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:guanjia/ui/wish_pavilion/charm/widgets/charm_top_up_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'app_exceptions.dart';

typedef DataConverter<T> = T Function(dynamic data);

///API响应对象
class ApiResponse<T> {
  final int code;
  final String? message;
  final T? data;
  final AppException? exception;

  bool get isSuccess => code == 0 && exception == null;

  ApiResponse({required this.code, this.message, this.data, this.exception});

  static ApiResponse<T> fromJson<T>(Map<String, dynamic> json, {final DataConverter<T>? dataConverter}) {
    final code = json['code'] as int;
    final message = json['msg'] as String?;
    final data = json['data'];
    AppException? exception;
    T? dataModel;
    try{
      if(code == 0){
        if (dataConverter != null) {
          dataModel = dataConverter.call(data);
        }else{
          dataModel = data;
        }
      }
    }catch(ex){
      exception = JsonParseException(-1, '数据解析失败');
    }

    return ApiResponse<T>(
      code: code,
      message: message,
      data: dataModel,
      exception: exception,
    );
  }

  static ApiResponse<T> fromBytes<T>(Uint8List bytes, {final DataConverter<T>? dataConverter}){
    final text = utf8.decode(bytes, allowMalformed: true);
    final json = jsonDecode(text) ?? {'code': -1, 'msg': '数据解析失败'};
    return fromJson<T>(json, dataConverter: dataConverter);
  }

  static ApiResponse<T> success<T>(T? data) {
    return ApiResponse<T>(
      code: 0,
      message: 'success',
      data: data,
    );
  }

  static ApiResponse<T> error<T>(AppException? exception) {
    return ApiResponse<T>(
      code: -1,
      exception: exception
    );
  }

  ///错误信息
  String? get errorMessage => isSuccess ? null : (message ?? exception?.message);

  ///显示错误信息
  void showErrorMessage() {
    //用户未登录有统一的提示对话框，这里不需要显示toast
    if([401, 4].contains(code)){
      return;
    }else if(code == 1103){
      Get.dialog(const CharmTopUpDialog());
      return;
    }
    final msg = errorMessage;
    if (msg != null && msg.isNotEmpty) {
      Loading.showToast(msg);
    }
  }


  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, data: $data, exception: $exception}';
  }
}
