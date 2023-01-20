import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/type_converters.dart';

class VCs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get vc => text()();
  TextColumn get types => text().map(StringListConverter())();
  TextColumn get activity => text().map(ActivityListConverter()).withDefault(const Constant("[]"))();
}
