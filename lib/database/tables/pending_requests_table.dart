import 'package:drift/drift.dart';

class PendingRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serviceEndpoint => text()();
  TextColumn get requestVp => text()();
  TextColumn get vp => text().nullable()();
  BoolColumn get error => boolean().nullable()();
}
