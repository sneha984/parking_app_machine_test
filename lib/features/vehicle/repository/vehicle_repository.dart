import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../models/vehicle_model.dart';

class VehicleRepository {
  VehicleRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://parking.api.salonsyncs.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<Vehicle>> getVehicles({
    int limit = 10,
    int skip = 0,
    String search = "",
  }) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final res = await _dio.post(
        '/machine-test/list',
        data: {"limit": limit, "skip": skip, "searchingText": search},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.statusCode == 201 && res.data is Map<String, dynamic>) {
        final list = res.data['data']?['list'] as List? ?? [];
        return list.map((item) => Vehicle.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Vehicle list error: $e');
      return [];
    }
  }

  Future<bool> createVehicle({
    required String name,
    required String model,
    required String color,
    required String vehicleNumber,
  }) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final res = await _dio.post(
        '/machine-test/create',
        data: {
          "name": name,
          "model": model,
          "color": color,
          "vehicleNumber": vehicleNumber,
          "createdAt": DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return res.statusCode == 201;
    } catch (e) {
      print('Create vehicle error: $e');
      return false;
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final res = await _dio.delete(
        '/machine-test/delete',
        data: {"vehicleId": vehicleId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return res.statusCode == 200;
    } catch (e) {
      print('Delete vehicle error: $e');
      return false;
    }
  }

  Future<bool> editVehicle({
    required String vehicleId,
    required String name,
    required String model,
    required String color,
    required String vehicleNumber,
  }) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final res = await _dio.put(
        '/machine-test/edit',
        data: {
          "vehicleId": vehicleId,
          "name": name,
          "model": model,
          "color": color,
          "vehicleNumber": vehicleNumber,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return res.statusCode == 200;
    } catch (e) {
      print('Edit vehicle error: $e');
      return false;
    }
  }
}
