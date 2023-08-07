import 'dart:async';

extension FutureExtensions<T> on Future<T> {
  Future<void> on<ERROR>({
    void Function(T)? onData,
    void Function()? onLoading,
    void Function(ERROR)? onError,
  }) async {
    final Completer<void> taskCompleter = Completer<void>();

    onLoading?.call();

    then(
      (data) {
        onData?.call(data);
        taskCompleter.complete();
      },
    ).catchError(
      (Object error) {
        if (error is ERROR) {
          onError?.call(error as ERROR);
          taskCompleter.complete();
        }
      },
    );

    return taskCompleter.future;
  }
}
