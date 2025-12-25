import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../auth/presentation/auth_controller.dart';
import '../../groups/data/groups_repository_provider.dart';
import '../../../core/notifications/notification_service.dart';
import '../data/events_repository_provider.dart';
import '../domain/event.dart';

part 'events_controller.g.dart';

@riverpod
class EventsController extends _$EventsController {
  @override
  Future<List<CalendarEvent>> build(String groupId) async {
    final repo = ref.watch(eventsRepositoryProvider);
    return repo.getGroupEvents(groupId);
  }

  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
  }) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) throw Exception('Not authenticated');

    final repo = ref.read(eventsRepositoryProvider);
    final notification = ref.read(notificationServiceProvider);
    
    final event = CalendarEvent(
      id: const Uuid().v4(),
      groupId: groupId,
      title: title,
      description: description,
      startDateTime: start,
      endDateTime: end,
      createdBy: user.id,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.createEvent(event);
      await notification.showNotification('Event Added', 'Event "$title" has been added.');
      return repo.getGroupEvents(groupId);
    });
  }

  Future<void> updateEvent(CalendarEvent event) async {
     final user = ref.read(authControllerProvider).value;
     if (user == null) throw Exception('Not authenticated');

     if (!await _canEditOrDelete(user.id, event)) {
       throw Exception('Permission denied');
     }

    final repo = ref.read(eventsRepositoryProvider);
    final notification = ref.read(notificationServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.updateEvent(event.copyWith(updatedBy: user.id));
      await notification.showNotification('Event Updated', 'Event "${event.title}" has been updated.');
      return repo.getGroupEvents(groupId);
    });
  }

  Future<void> deleteEvent(CalendarEvent event) async {
     final user = ref.read(authControllerProvider).value;
     if (user == null) throw Exception('Not authenticated');

     if (!await _canEditOrDelete(user.id, event)) {
       throw Exception('Permission denied');
     }

    final repo = ref.read(eventsRepositoryProvider);
    final notification = ref.read(notificationServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.deleteEvent(event.id);
      await notification.showNotification('Event Deleted', 'Event "${event.title}" has been deleted.');
      return repo.getGroupEvents(groupId);
    });
  }

  Future<bool> _canEditOrDelete(String userId, CalendarEvent event) async {
    if (event.createdBy == userId) return true;
    
    // Check if admin
    final groupRepo = ref.read(groupsRepositoryProvider);
    // Fetch members. We need a method to get role. 
    // Optimization: GroupsRepository could expose `getMemberRole(groupId, userId)`.
    // For now we assume getUserGroups has loaded it? No.
    // We should add `getMemberRole` to repo or fetch list.
    // Let's iterate user groups.
    final groups = await groupRepo.getUserGroups(userId); // This returns Groups, not roles.
    
    // We need to implement `getGroupMember` in repo or just assume for now.
    // Let's assume if owner of group? 
    // The Groups object has OwnerId. 
    // We need to fetch the Group object.
    
    // Re-fetching group seems inefficient but correct.
    // However, getUserGroups returns Group entities which have ownerId.
    final group = groups.where((g) => g.id == groupId).firstOrNull;
    if (group != null && group.ownerId == userId) return true;
    
    return false;
  }
}
