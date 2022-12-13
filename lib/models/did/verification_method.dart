import 'package:json_annotation/json_annotation.dart';

import './public_key.dart';

part 'verification_method.g.dart';

@JsonSerializable()
class VerificationMethod {
  String id;
  String type;
  String controller;
  PublicKey publicKeyJwk;

  VerificationMethod({
    required this.id,
    required this.type,
    required this.controller,
    required this.publicKeyJwk,
  });

  factory VerificationMethod.fromJson(Map<String, dynamic> json) => _$VerificationMethodFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationMethodToJson(this);

  @override
  String toString() {
    return 'VerificationMethod(id: $id, type: $type, controller: $controller, publicKeyJwk: $publicKeyJwk)';
  }
}
