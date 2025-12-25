import 'auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> login(String email, String password);
  Future<AuthUser?> register(String email, String password, String displayName);
  Future<void> logout();
  Future<AuthUser?> getCurrentUser();
  Future<AuthUser?> getUserByEmail(String email);
  Future<List<AuthUser>> getAllUsers();
}
