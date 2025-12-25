import 'package:drift/drift.dart';
import 'groups.dart';
import 'users.dart';

class Events extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDateTime => dateTime()();
  DateTimeColumn get endDateTime => dateTime()();
  TextColumn get createdBy => text().references(Users, #id)();
  TextColumn get updatedBy => text().nullable().references(Users, #id)();
  
  @override
  Set<Column> get primaryKey => {id};
}
