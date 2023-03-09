import 'package:drift/drift.dart';

class PendingRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serviceEndpoint => text()();
  TextColumn get vp => text()();
  TextColumn get vpVc => text().nullable()();
  BoolColumn get error => boolean().nullable()();
}
