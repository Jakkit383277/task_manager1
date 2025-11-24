sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}

// Extension methods เพื่อให้ใช้งานง่ายขึ้น
extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get valueOrNull {
    return switch (this) {
      Success(:final value) => value,
      Failure() => null,
    };
  }

  void onSuccess(void Function(T) action) {
    if (this case Success(:final value)) action(value);
  }

  void onFailure(void Function(String) action) {
    if (this case Failure(:final error)) action(error);
  }
}