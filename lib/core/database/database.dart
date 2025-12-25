import 'package:drift/drift.dart';
import 'tables/users.dart';
import 'tables/groups.dart';
import 'tables/events.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

@DriftDatabase(tables: [Users, Groups, GroupMembers, Events])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
