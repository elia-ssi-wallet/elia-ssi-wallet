import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/database/tables/pending_requests_table.dart';

part 'pending_requests_dao.drift.dart';

@DriftAccessor(tables: [PendingRequests])
class PendingRequestsDao extends DatabaseAccessor<Database> with _$PendingRequestsDaoMixin {
  PendingRequestsDao(Database attachedDatabase) : super(attachedDatabase);

  Future<int> insertPendingRequests({required String serviceEndpoint, required dynamic requestVp}) async {
    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      serviceEndpoint: serviceEndpoint,
      requestVp: jsonEncode(requestVp),
    );

    return await into(pendingRequests).insert(newPendingRequest);
  }

  Future<void> updatePendingRequests({required int id, required dynamic vp}) async {
    PendingRequest pendingRequest = await getPendingRequestsWithId(id: id);

    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      id: Value(id),
      serviceEndpoint: pendingRequest.serviceEndpoint,
      requestVp: pendingRequest.requestVp,
      vp: Value(jsonEncode(vp)),
    );

    await into(pendingRequests).insertOnConflictUpdate(newPendingRequest);
  }

  Future<void> insertTestPendingRequests() async {
    PendingRequestsCompanion newPendingRequest = PendingRequestsCompanion.insert(
      serviceEndpoint: testServiceEndpoint,
      requestVp: jsonEncode(testvp),
    );

    await into(pendingRequests).insert(newPendingRequest);
  }

  Future<void> updatePendingRequest({required int id, required dynamic vp}) async {
    (update(pendingRequests)
      ..where((tbl) => tbl.id.equals(id))
      ..write(
        PendingRequestsCompanion(vp: Value(jsonEncode(vp))),
      ));
  }

  Future<void> updatePendingRequestWithError({required int id}) async {
    (update(pendingRequests)
      ..where((tbl) => tbl.id.equals(id))
      ..write(
        const PendingRequestsCompanion(error: Value(true)),
      ));
  }

  Future<void> deletePendingRequestWithId({required int id}) => (delete(pendingRequests)..where((tbl) => tbl.id.equals(id))).go();

  Future<List<PendingRequest>> getPendingRequestsNotCompleted() => (select(pendingRequests)..where((tbl) => tbl.vp.isNull())).get();

  Stream<List<PendingRequest>> requestsStream() => select(pendingRequests).watch();

  Stream<List<PendingRequest>> pendingRequestsStream() => (select(pendingRequests)..where((tbl) => tbl.vp.isNull())).watch();

  Future<PendingRequest> getPendingRequestsWithId({required int id}) => (select(pendingRequests)
        ..where((tbl) => tbl.id.equals(id))
        ..limit(1))
      .getSingle();

  Future<PendingRequest?> getPendingRequestsWithExchangeId({required String exchangeId}) => (select(pendingRequests)
        ..where((tbl) => tbl.serviceEndpoint.contains(exchangeId))
        ..limit(1))
      .getSingleOrNull();

  void deleteAll() => delete(pendingRequests).go();
}

String testServiceEndpoint = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test";

dynamic testvp = {
  "@context": ["https://www.w3.org/2018/credentials/v1"],
  "type": "VerifiablePresentation",
  "proof": {
    "type": "Ed25519Signature2018",
    "proofPurpose": "authentication",
    "challenge": "deda8d6e-c4d1-44cf-ba90-628a736ff29b",
    "verificationMethod": "did:key:z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA#z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA",
    "created": "2023-01-18T10:30:44.988Z",
    "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..geKwdwg5njE47U8p446kcXqImioO-fnAQ1-PsiLOgeMojgYJKeqHEzio6h45ykwkAYxr53H9NUAmboYwbYPKAA"
  },
  "holder": "did:key:z6MkpvchYYdazv5nxdgzKAjs6kH4CrTpSyprxx8ABRFcxUNA"
};
