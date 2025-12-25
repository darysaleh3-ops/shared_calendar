import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../domain/groups_repository.dart';
import 'groups_repository_impl.dart';

part 'groups_repository_provider.g.dart';

@Riverpod(keepAlive: true)
GroupsRepository groupsRepository(GroupsRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  return GroupsRepositoryImpl(db);
}
