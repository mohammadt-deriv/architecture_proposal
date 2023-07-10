abstract class DataSource {
  Future<Map<String, dynamic>> request({
    required Map<String, dynamic> request,
  });

  Future<(Stream<Map<String, dynamic>> data, String subscriptionId)>
      requestStream({required Map<String, dynamic> request});
}
