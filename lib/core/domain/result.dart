sealed class Result<T, E> {
  const Result();

  W fold<W>(W Function(T success) onSuccess, W Function(E error) onFailure) {
    return switch (this) {
      Success(value: final s) => onSuccess(s),
      Failure(error: final e) => onFailure(e),
    };
  }

  Result<W, E> map<W>(W Function(T success) transform) {
    return switch (this) {
      Success(value: final s) => Success(transform(s)),
      Failure(error: final e) => Failure(e),
    };
  }

  T get unwrap => switch (this) {
    Success(value: final s) => s,
    Failure() => throw StateError('Attempted to unwrap a Failure.'),
  };
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);

  final T value;
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);

  final E error;
}
