import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;
  final SharedPreferences _prefs;
  static const _kCurrentUserKey = 'current_user_id';

  AuthRepositoryImpl(this._db, this._prefs);

  @override
  Future<AuthUser?> getCurrentUser() async {
    final userId = _prefs.getString(_kCurrentUserKey);
    if (userId == null) return null;

    final user = await (_db.select(_db.users)
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();
    if (user == null) {
      await _prefs.remove(_kCurrentUserKey);
      return null;
    }
    return _mapToDomain(user);
  }

  @override
  Future<AuthUser?> login(String email, String password) async {
    // Mock password check: We just check if user exists for now,
    // in real app we'd hash and compare.
    final user = await (_db.select(_db.users)
          ..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();

    if (user != null) {
      // Mock validation
      if (user.passwordHash == password) {
        await _prefs.setString(_kCurrentUserKey, user.id);
        return _mapToDomain(user);
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_kCurrentUserKey);
  }

  @override
  Future<AuthUser?> register(
      String email, String password, String displayName) async {
    final id = const Uuid().v4();
    final companion = UsersCompanion(
      id: Value(id),
      email: Value(email),
      passwordHash: Value(password),
      displayName: Value(displayName),
    );

    // Check if exists
    try {
      await _db.into(_db.users).insert(companion);
      await _prefs.setString(_kCurrentUserKey, id);
      return AuthUser(id: id, email: email, displayName: displayName);
    } catch (e) {
      // Likely unique constraint violation
      return null;
    }
  }

  AuthUser _mapToDomain(User user) {
    return AuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  Future<AuthUser?> getUserByEmail(String email) async {
    final user = await (_db.select(_db.users)
          ..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();
    return user != null ? _mapToDomain(user) : null;
  }

  @override
  Future<List<AuthUser>> getAllUsers() async {
    final users = await _db.select(_db.users).get();
    return users.map(_mapToDomain).toList();
  }
}
