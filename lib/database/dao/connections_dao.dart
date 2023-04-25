import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/database/tables/connections_table.dart';

part 'connections_dao.drift.dart';

@DriftAccessor(tables: [Connections])
class ConnectionsDao extends DatabaseAccessor<Database> with _$ConnectionsDaoMixin {
  ConnectionsDao(Database attachedDatabase) : super(attachedDatabase);

  Future<int> insertConnection({required String connectionName}) async {
    ConnectionsCompanion newConnection = ConnectionsCompanion.insert(
      name: connectionName,
    );

    return await into(connections).insert(newConnection);
  }

  Future<List<Connection>> getConnections() => select(connections).get();

  Future<Connection?> getConnectionWithName({required String name}) => (select(connections)..where((tbl) => tbl.name.equals(name))).getSingleOrNull();

  Stream<List<Connection>> connectionsStream() => select(connections).watch();

  void deleteAll() => delete(connections).go();
}
