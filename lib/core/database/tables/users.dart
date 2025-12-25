import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get passwordHash => text()(); // Mock password
  
  @override
  Set<Column> get primaryKey => {id};
}
