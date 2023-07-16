abstract class DataSource {
  Future<Map<String, dynamic>> request({
    required Map<String, dynamic> request,
  });

  // TODO convert return type to Stream<Map<String, dynamic>>
  Future<Stream<Map<String, dynamic>>> requestStream(
      {required Map<String, dynamic> request});
}
