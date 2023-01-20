import 'package:drift/drift.dart';

class Connections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
