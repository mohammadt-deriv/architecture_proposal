extension FutureExtensions<T> on Future<T> {
  void on({
    void Function(T)? onData,
    void Function()? onLoading,
    void Function(Object)? onError,
  }) {
    onLoading?.call();

    then(
      (data) => onData?.call(data),
    ).catchError(
      (Object error) => onError?.call(error),
    );
  }
}
