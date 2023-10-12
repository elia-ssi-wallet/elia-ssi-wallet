import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/database/tables/all_tables.dart';
import 'package:elia_ssi_wallet/database/dao/all_daos.dart';
// export 'database_shared/mobile.dart';

part 'database.drift.dart';

// ! flutter pub run build_runner watch --delete-conflicting-outputs

@DriftDatabase(tables: [VCs, PendingRequests, Connections], daos: [VCsDao, PendingRequestsDao, ConnectionsDao])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 16;

  Future<void> deleteDatabase() async {
    await transaction(() async {
      // Deleting tables in reverse topological order to avoid foreign-key conflicts
      final tables = database.allTables.toList();

      for (final table in tables) {
        await delete(table).go();
      }
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (m, from, to) async {
          if (from < to) {
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }
          await logout();
        },
      );
}
