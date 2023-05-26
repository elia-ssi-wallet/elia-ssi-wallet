import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/type_converters.dart';

class VCs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get issuerLabel => text()();
  TextColumn get title => text()();
  TextColumn get vc => text()();
  TextColumn get issuerDid => text()();
  DateTimeColumn get issuanceDate => dateTime()();
  TextColumn get types => text().map(StringListConverter())();
  TextColumn get activity => text().map(ActivityListConverter()).withDefault(const Constant("[]"))();
}
