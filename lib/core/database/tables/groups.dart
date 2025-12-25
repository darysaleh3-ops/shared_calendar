import 'package:drift/drift.dart';
import 'users.dart';

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  
  @override
  Set<Column> get primaryKey => {id};
}

class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().references(Groups, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get role => text()(); // 'admin', 'member'
}
