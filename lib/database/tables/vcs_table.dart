import 'package:drift/drift.dart';

class VCs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get vc => text()();
}
