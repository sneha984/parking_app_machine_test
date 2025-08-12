import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://parking.api.salonsyncs.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String mobile, String password) async {
    try {
      final res = await _dio.post(
        '/machine-test/login',
        data: {
          'mobile': mobile,
          'password': password,
        },
      );

      print('Login API response: ${res.data}');

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        final token = data['accessToken'] ?? '';
        if (token.isNotEmpty) {
          await _secureStorage.write(key: 'accessToken', value: token);
          print('Token $token');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'accessToken');
  }
}
