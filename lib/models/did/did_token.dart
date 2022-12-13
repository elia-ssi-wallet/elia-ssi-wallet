import 'package:json_annotation/json_annotation.dart';

import './verification_method.dart';

part 'did_token.g.dart';

@JsonSerializable()
class DIDToken {
  String id;
  List<VerificationMethod> verificationMethod;

  DIDToken({
    required this.id,
    required this.verificationMethod,
  });

  factory DIDToken.fromJson(Map<String, dynamic> json) => _$DIDTokenFromJson(json);

  Map<String, dynamic> toJson() => _$DIDTokenToJson(this);

  @override
  String toString() => 'DIDToken(id: $id, verificationMethod: $verificationMethod)';
}
