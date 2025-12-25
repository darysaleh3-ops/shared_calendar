import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../domain/event.dart';
import '../domain/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  final AppDatabase _db;

  EventsRepositoryImpl(this._db);

  @override
  Future<List<CalendarEvent>> getGroupEvents(String groupId) async {
    final query = _db.select(_db.events)
      ..where((t) => t.groupId.equals(groupId));
    final rows = await query.get();

    return rows
        .map((row) => CalendarEvent(
              id: row.id,
              groupId: row.groupId,
              title: row.title,
              description: row.description,
              startDateTime: row.startDateTime,
              endDateTime: row.endDateTime,
              createdBy: row.createdBy,
              updatedBy: row.updatedBy,
            ))
        .toList();
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    await _db.into(_db.events).insert(EventsCompanion(
          id: Value(event.id),
          groupId: Value(event.groupId),
          title: Value(event.title),
          description: Value(event.description),
          startDateTime: Value(event.startDateTime),
          endDateTime: Value(event.endDateTime),
          createdBy: Value(event.createdBy),
          updatedBy: Value(event.updatedBy),
        ));
    return event;
  }

  @override
  Future<void> updateEvent(CalendarEvent event) async {
    await (_db.update(_db.events)..where((t) => t.id.equals(event.id)))
        .write(EventsCompanion(
      title: Value(event.title),
      description: Value(event.description),
      startDateTime: Value(event.startDateTime),
      endDateTime: Value(event.endDateTime),
      updatedBy: Value(event.updatedBy),
    ));
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await (_db.delete(_db.events)..where((t) => t.id.equals(eventId))).go();
  }
}
