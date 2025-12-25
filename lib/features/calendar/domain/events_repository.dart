import 'event.dart';

abstract class EventsRepository {
  Future<List<CalendarEvent>> getGroupEvents(String groupId);
  Future<CalendarEvent> createEvent(CalendarEvent event);
  Future<void> updateEvent(CalendarEvent event);
  Future<void> deleteEvent(String eventId);
}
