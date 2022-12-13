import 'package:json_annotation/json_annotation.dart';

part 'public_key.g.dart';

@JsonSerializable()
class PublicKey {
  String crv;
  String x;
  String kty;
  String kid;

  PublicKey({
    required this.crv,
    required this.x,
    required this.kty,
    required this.kid,
  });

  factory PublicKey.fromJson(Map<String, dynamic> json) => _$PublicKeyFromJson(json);

  Map<String, dynamic> toJson() => _$PublicKeyToJson(this);

  @override
  String toString() {
    return 'PublicKey(crv: $crv, x: $x, kty: $kty, kid: $kid)';
  }
}
