import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository repo;
  AuthController(this.repo) : super(false);

  Future<bool> login(String mobile, String password) async {
    final success = await repo.login(mobile, password);
    if (success) state = true;
    return success;
  }

  Future<void> logout() async {
    await repo.logout();
    state = false;
  }
}
