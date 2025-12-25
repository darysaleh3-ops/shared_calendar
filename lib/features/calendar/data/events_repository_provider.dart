import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../domain/events_repository.dart';
import 'events_repository_impl.dart';

part 'events_repository_provider.g.dart';

@Riverpod(keepAlive: true)
EventsRepository eventsRepository(EventsRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  return EventsRepositoryImpl(db);
}
