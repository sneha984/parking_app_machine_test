import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/vehicle_model.dart';
import '../repository/vehicle_repository.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository();
});

final paginatedVehicleListProvider =
    StateNotifierProvider<VehiclePaginationNotifier, AsyncValue<List<Vehicle>>>(
        (ref) {
  final repo = ref.read(vehicleRepositoryProvider);
  return VehiclePaginationNotifier(repo);
});

class VehiclePaginationNotifier
    extends StateNotifier<AsyncValue<List<Vehicle>>> {
  VehiclePaginationNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchVehicles();
  }

  final VehicleRepository _repo;
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  Future<void> fetchVehicles({bool refresh = false}) async {
    if (_isLoadingMore) return;
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }
    if (!_hasMore) return;

    _isLoadingMore = true;
    try {
      final newVehicles = await _repo.getVehicles(limit: _limit, skip: _skip);
      if (refresh) {
        state = AsyncValue.data(newVehicles);
      } else {
        state = AsyncValue.data([
          ...state.value ?? [],
          ...newVehicles,
        ]);
      }
      if (newVehicles.length < _limit) _hasMore = false;
      _skip += _limit;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    _isLoadingMore = false;
  }
}

final vehicleControllerProvider =
    StateNotifierProvider<VehicleController, AsyncValue<void>>((ref) {
  final repo = ref.read(vehicleRepositoryProvider);
  return VehicleController(repo);
});

class VehicleController extends StateNotifier<AsyncValue<void>> {
  final VehicleRepository _repo;
  VehicleController(this._repo) : super(const AsyncValue.data(null));

  Future<bool> createVehicle({
    required String name,
    required String model,
    required String color,
    required String vehicleNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.createVehicle(
        name: name,
        model: model,
        color: color,
        vehicleNumber: vehicleNumber,
      );
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.deleteVehicle(vehicleId);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
    state = const AsyncValue.loading();
    try {
      final result = await _repo.editVehicle(
        vehicleId: vehicleId,
        name: name,
        model: model,
        color: color,
        vehicleNumber: vehicleNumber,
      );
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
