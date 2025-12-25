import 'group.dart';
import '../../auth/domain/auth_user.dart';

abstract class GroupsRepository {
  Future<List<Group>> getUserGroups(String userId);
  Future<Group> createGroup(String name, String ownerId);
  Future<Group?> getGroup(String groupId);
  Future<List<AuthUser>> getGroupMembers(String groupId);
  Future<void> addMember(String groupId, String userId, String role);
  Future<void> removeMember(String groupId, String userId);
  Future<void> deleteGroup(String groupId);
}
