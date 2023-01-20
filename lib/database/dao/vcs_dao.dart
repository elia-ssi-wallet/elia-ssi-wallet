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

  Future<VC> insertVCs({required dynamic vc, required String label}) async {
    VCsCompanion newVC = VCsCompanion.insert(
      label: label,
      vc: jsonEncode(vc),
      types: vc["type"].cast<String>(),
    );

    int id = await into(vCs).insert(newVC);
    return await getVCWithId(id: id);
  }

  Future<VC> insertTestVC() async {
    VCsCompanion newVC = VCsCompanion.insert(
      label: 'test ${Random().nextInt(100)}',
      vc: jsonEncode(testVC),
      types: testVC[0]["type"],
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

    int response = await into(vCs).insert(newVC);
    return await getVCWithId(id: response);
  }

  Future<void> deleteVCs() => delete(vCs).go();

  Future<void> deleteVC({required int vcId}) => (delete(vCs)..where((tbl) => tbl.id.equals(vcId))).go();

  Future<List<VC>> getVCs() => select(vCs).get();

  Stream<List<VC>> vCsStream() => select(vCs).watch();

  Future<VC> getVCWithId({required int id}) => (select(vCs)
        ..where((tbl) => tbl.id.equals(id))
        ..limit(1))
      .getSingle();

  Stream<List<VC>> searchVcStream(String? query) => (select(vCs)
        ..where((tbl) {
          if (query == null) {
            return tbl.id.isNotNull(); //return true
          } else {
            return tbl.label.lower().contains(query.toLowerCase()) | tbl.types.contains(query.toLowerCase());
          }
        }))
      .watch();
  //     .map((event) {
  //   return event.where((element) => element.types.map((e) => e.toLowerCase()).contains(query?.toLowerCase())).toList();
  // });
}

dynamic testVC = [
  {
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
  }
];
