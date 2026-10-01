class SessionStore {
  // TODO: back this with flutter_secure_storage
  String? _token;

  Future<void> saveToken(String token) async => _token = token;
  Future<String?> getToken() async => _token;
  Future<void> clear() async => _token = null;
}