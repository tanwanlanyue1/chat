/// 用户处理成功和失败两种情况
// 定义一个泛型 Result 枚举
enum ResultType { success, failure }

// 封闭类表示 Success 和 Failure
abstract class Result<Success, Failure> {
  const Result();

  // 判断是否是成功
  bool get isSuccess => this is ResultSuccess<Success, Failure>;

  // 判断是否是失败
  bool get isFailure => this is ResultFailure<Success, Failure>;

  // 使用 when 方法来处理不同情况
  T when<T>({
    required T Function(Success success) success,
    required T Function(Failure failure) failure,
  }) {
    if (this is ResultSuccess<Success, Failure>) {
      return success((this as ResultSuccess<Success, Failure>).value);
    } else if (this is ResultFailure<Success, Failure>) {
      return failure((this as ResultFailure<Success, Failure>).error);
    }
    throw AssertionError('Unexpected subclass of Result');
  }

  Future<T> whenAsync<T>({
    required Future<T> Function(Success success) success,
    required Future<T> Function(Failure failure) failure,
  }) async {
    if (this is ResultSuccess<Success, Failure>) {
      return await success((this as ResultSuccess<Success, Failure>).value);
    } else if (this is ResultFailure<Success, Failure>) {
      return await failure((this as ResultFailure<Success, Failure>).error);
    }
    throw AssertionError('Unexpected subclass of Result');
  }
}

// 成功结果子类
class ResultSuccess<Success, Failure> extends Result<Success, Failure> {
  final Success value;
  const ResultSuccess(this.value);
}

// 失败结果子类
class ResultFailure<Success, Failure> extends Result<Success, Failure> {
  final Failure error;
  const ResultFailure(this.error);
}
