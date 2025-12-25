import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import '../domain/auth_repository.dart';
import 'auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AuthRepository> authRepository(AuthRepositoryRef ref) async {
  final db = ref.watch(databaseProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthRepositoryImpl(db, prefs);
}
