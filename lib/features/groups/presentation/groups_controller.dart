import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/data/auth_repository_provider.dart';
import '../data/groups_repository_provider.dart';
import '../domain/group.dart';

import '../../auth/domain/auth_user.dart';

part 'groups_controller.g.dart';

@riverpod
class GroupsController extends _$GroupsController {
  @override
  Future<List<Group>> build() async {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return [];

    final repo = ref.watch(groupsRepositoryProvider);
    return repo.getUserGroups(user.id);
  }

  Future<void> createGroup(String name) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final repo = ref.read(groupsRepositoryProvider);

    try {
      await repo.createGroup(name, user.id);
      // Invalidate self so that the list refreshes
      ref.invalidateSelf();
    } catch (e) {
      // Re-throw so the UI can catch it and show a SnackBar
      rethrow;
    }
  }

  Future<void> addMember(String groupId, String email) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final repo = ref.read(groupsRepositoryProvider);
    final authRepo = await ref.read(authRepositoryProvider.future);

    // 1. Find user by email
    final memberUser = await authRepo.getUserByEmail(email);
    if (memberUser == null) {
      throw Exception('User with email $email not found');
    }

    // 2. Add as 'member'
    await repo.addMember(groupId, memberUser.id, 'member');

    // Refresh the members list
    ref.invalidate(groupMembersProvider(groupId));
  }

  Future<void> deleteGroup(String groupId) async {
    final repo = ref.read(groupsRepositoryProvider);
    await repo.deleteGroup(groupId);
    // Invalidate list
    ref.invalidateSelf();
  }
}

@riverpod
Future<Group?> groupDetails(GroupDetailsRef ref, String groupId) {
  return ref.watch(groupsRepositoryProvider).getGroup(groupId);
}

@riverpod
Future<List<AuthUser>> availableUsers(AvailableUsersRef ref) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  return authRepo.getAllUsers();
}

@riverpod
Future<List<AuthUser>> groupMembers(GroupMembersRef ref, String groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  return repo.getGroupMembers(groupId);
}
