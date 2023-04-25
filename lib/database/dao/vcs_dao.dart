import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/database/tables/vcs_table.dart';
import 'package:elia_ssi_wallet/models/activity.dart';

part 'vcs_dao.drift.dart';

@DriftAccessor(tables: [VCs])
class VCsDao extends DatabaseAccessor<Database> with _$VCsDaoMixin {
  VCsDao(Database attachedDatabase) : super(attachedDatabase);

  Future<void> insertVC({required dynamic vc, required String label}) async {
    VCsCompanion newVC = VCsCompanion.insert(
      label: label,
      vc: jsonEncode(vc),
      issuer: vc["issuer"],
      issuanceDate: DateTime.parse(vc["issuanceDate"]),
      types: vc["type"].cast<String>(),
    );

    await into(vCs).insert(newVC);
  }

  Future<void> insertTestVC() async {
    VCsCompanion newVC = VCsCompanion.insert(
      label: 'test ${Random().nextInt(100)}',
      vc: jsonEncode(testVC),
      types: testVC[0]["type"],
      issuer: testVC["issuer"],
      issuanceDate: DateTime.parse(testVC["issuanceDate"]),
      activity: Value(
        [
          Activity(
            name: 'test name 1',
            date: DateTime.now(),
          ),
          Activity(
            name: 'test name 2',
            date: DateTime.now(),
          ),
          Activity(
            name: 'test name 3',
            date: DateTime.now(),
          ),
          Activity(
            name: 'test name 4',
            date: DateTime.now(),
          ),
          Activity(
            name: 'test name 5',
            date: DateTime.now(),
          ),
        ],
      ),
    );

    await into(vCs).insert(newVC);
  }

  Future<void> deleteVC({required int vcId}) => (delete(vCs)..where((tbl) => tbl.id.equals(vcId))).go();

  Stream<List<VC>> externalVCsStream({required String id}) => (select(vCs)..where((tbl) => tbl.issuer.equals(id).not())).watch();

  Stream<List<VC>> searchExternalVcsStream({required String? query, required String id}) => (select(vCs)
        ..where((tbl) {
          if (query == null) {
            return tbl.issuer.equals(id).not();
          } else {
            return (tbl.label.lower().contains(query.toLowerCase()) | tbl.types.contains(query.toLowerCase())) & tbl.issuer.equals(id).not();
          }
        }))
      .watch();

  Stream<List<VC>> selfSignedVCsStream({required String id}) => (select(vCs)..where((tbl) => tbl.issuer.equals(id))).watch();

  Stream<List<VC>> searchSelfSignedVcsStream({required String? query, required String id}) => (select(vCs)
        ..where((tbl) {
          if (query == null) {
            return tbl.issuer.equals(id);
          } else {
            return (tbl.label.lower().contains(query.toLowerCase()) | tbl.types.contains(query.toLowerCase())) & tbl.issuer.equals(id);
          }
        }))
      .watch();

  Future<void> insertUniqueVCs({required List<dynamic> vCsList, required String exchangeBaseUrl}) async {
    final storedVCsList = await (select(vCs).get());

    for (var inputVC in vCsList) {
      bool matchFound = false;
      VC? matchVC;

      for (var storedVC in storedVCsList) {
        Map<String, dynamic> decodedStoredVC = jsonDecode(storedVC.vc);

        if (inputVC['credentialSubject'].toString() == decodedStoredVC['credentialSubject'].toString()) {
          matchVC = storedVC;
          matchFound = true;
          break;
        }
      }

      if (matchFound) {
        if (matchVC != null) {
          matchVC.activity.add(
            Activity(
              name: exchangeBaseUrl,
              date: DateTime.now(),
            ),
          );
          await into(vCs).insertOnConflictUpdate(matchVC);
        }
      } else {
        insertVC(vc: inputVC, label: '');
      }
    }
  }

  Future<List<VC>> searchVcFuture(List<String> query) => (select(vCs)..where((tbl) => query.map((q) => tbl.types.contains(q)).reduce((a, b) => a | b))).get();
}

dynamic testVC = {
  "@context": ["https://www.w3.org/2018/credentials/v1", "https://w3id.org/citizenship/v1"],
  "id": "https://issuer.oidp.uscis.gov/credentials/83627465",
  "type": ["VerifiableCredential", "PermanentResidentCard"],
  "credentialSubject": {
    "id": "did:key:z6MkjuUkSGesm8pNUHcNpCNv6uAy9F637rTgXBAk6zk7TEei",
    "givenName": "JOHN",
    "familyName": "SMITH",
    "commuterClassification": "C1",
    "lprNumber": "999-999-999",
    "lprCategory": "C09",
    "type": ["PermanentResident", "Person"],
    "image": "data:image/png;base64,iVBORw0KGgo...kJggg==",
    "gender": "Male",
    "residentSince": "2015-01-01",
    "birthCountry": "Bahamas",
    "birthDate": "1958-07-17"
  },
  "issuer": "did:key:z6MkqkXimG8uEEGwdWTyH4tLAZpq7i2KDPqbGTpjqonMNZ9P",
  "issuanceDate": "2023-01-04T20:48:39+00:00",
  "proof": {
    "type": "Ed25519Signature2018",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:key:z6MkqkXimG8uEEGwdWTyH4tLAZpq7i2KDPqbGTpjqonMNZ9P#z6MkqkXimG8uEEGwdWTyH4tLAZpq7i2KDPqbGTpjqonMNZ9P",
    "created": "2023-01-04T20:48:40.603Z",
    "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..rm6MzKojdy29nb4VHzslS4fwKOnc5PCP_XzvzKeBEf3MfJL1gjqNAG5ZfSXkij4w_waCUaY4VjybY135j6wiBA"
  },
  "expirationDate": "2026-03-07T06:35:19+00:00"
};
