import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart' as db_module;
import '../domain/group.dart';
import '../domain/groups_repository.dart';
import '../../auth/domain/auth_user.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final db_module.AppDatabase _db;

  GroupsRepositoryImpl(this._db);

  @override
  Future<List<Group>> getUserGroups(String userId) async {
    // Join Groups with GroupMembers
    final query = _db.select(_db.groups).join([
      innerJoin(
        _db.groupMembers,
        _db.groupMembers.groupId.equalsExp(_db.groups.id),
      ),
    ])
      ..where(_db.groupMembers.userId.equals(userId));

    final rows = await query.get();
    return rows.map((row) {
      final groupData = row.readTable(_db.groups);
      return Group(
          id: groupData.id, name: groupData.name, ownerId: groupData.ownerId);
    }).toList();
  }

  @override
  Future<Group?> getGroup(String groupId) async {
    final group = await (_db.select(_db.groups)
          ..where((tbl) => tbl.id.equals(groupId)))
        .getSingleOrNull();
    if (group == null) return null;
    return Group(id: group.id, name: group.name, ownerId: group.ownerId);
  }

  @override
  Future<List<AuthUser>> getGroupMembers(String groupId) async {
    // Join GroupMembers with Users
    final query = _db.select(_db.users).join([
      innerJoin(
        _db.groupMembers,
        _db.groupMembers.userId.equalsExp(_db.users.id),
      ),
    ])
      ..where(_db.groupMembers.groupId.equals(groupId));

    final rows = await query.get();
    return rows.map((row) {
      final user = row.readTable(_db.users);
      return AuthUser(
          id: user.id, email: user.email, displayName: user.displayName);
    }).toList();
  }

  @override
  Future<Group> createGroup(String name, String ownerId) async {
    // Check for duplicate name for this owner
    final existingGroup = await (_db.select(_db.groups)
          ..where((t) => t.name.equals(name) & t.ownerId.equals(ownerId)))
        .getSingleOrNull();

    if (existingGroup != null) {
      throw Exception('You already have a group named "$name"');
    }

    final groupId = const Uuid().v4();

    return await _db.transaction(() async {
      // 1. Create Group
      await _db.into(_db.groups).insert(db_module.GroupsCompanion(
            id: Value(groupId),
            name: Value(name),
            ownerId: Value(ownerId),
          ));

      // 2. Add Owner as Admin
      await _db.into(_db.groupMembers).insert(db_module.GroupMembersCompanion(
            groupId: Value(groupId),
            userId: Value(ownerId),
            role: const Value('admin'),
          ));

      return Group(id: groupId, name: name, ownerId: ownerId);
    });
  }

  @override
  Future<void> addMember(String groupId, String userId, String role) async {
    final exists = await (_db.select(_db.groupMembers)
          ..where((t) => t.groupId.equals(groupId) & t.userId.equals(userId)))
        .getSingleOrNull();

    if (exists != null) {
      throw Exception('User is already a member of this group');
    }

    await _db.into(_db.groupMembers).insert(db_module.GroupMembersCompanion(
          groupId: Value(groupId),
          userId: Value(userId),
          role: Value(role),
        ));
  }

  @override
  Future<void> removeMember(String groupId, String userId) async {
    await (_db.delete(_db.groupMembers)
          ..where((t) => t.groupId.equals(groupId) & t.userId.equals(userId)))
        .go();
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _db.transaction(() async {
      // 1. Delete all members
      await (_db.delete(_db.groupMembers)
            ..where((t) => t.groupId.equals(groupId)))
          .go();

      // 2. Delete all events (optional, if we link events to group)
      // For now, assuming events are linked to group?
      // User hasn't asked for event cleanup but we should probably do it if schema supports it.
      // Let's check schema later. For now, delete group.

      // 3. Delete group
      await (_db.delete(_db.groups)..where((t) => t.id.equals(groupId))).go();
    });
  }
}
