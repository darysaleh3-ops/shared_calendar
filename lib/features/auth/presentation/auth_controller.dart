import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/auth_user.dart';
import '../data/auth_repository_provider.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthUser?> build() async {
    final repo = await ref.watch(authRepositoryProvider.future);
    return repo.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final repo = await ref.read(authRepositoryProvider.future);
        final user = await repo.login(email, password);
        if (user == null) {
          throw Exception(
              'Login failed: Invalid credentials or user not found');
        }
        return user;
      } catch (e, st) {
        // ignore: avoid_print
        print('Login Error: $e\n$st');
        rethrow;
      }
    });
  }

  Future<void> register(
      String email, String password, String displayName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final repo = await ref.read(authRepositoryProvider.future);
        final user = await repo.register(email, password, displayName);
        if (user == null) {
          throw Exception('Registration failed: Email might be taken');
        }
        return user;
      } catch (e) {
        // ignore: avoid_print
        print('Registration Error: $e');
        rethrow;
      }
    });
  }

  Future<void> logout() async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.logout();
    state = const AsyncData(null);
  }
}
