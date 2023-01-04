import 'package:json_annotation/json_annotation.dart';

part 'private_key.g.dart';

@JsonSerializable()
class PrivateKey {
  String crv;
  String d;
  String x;
  String kty;

  PrivateKey({
    required this.crv,
    required this.d,
    required this.x,
    required this.kty,
  });

  factory PrivateKey.fromJson(Map<String, dynamic> json) => _$PrivateKeyFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateKeyToJson(this);

  @override
  String toString() {
    return 'PrivateKey(crv: $crv, d: $d, x: $x, kty: $kty)';
  }
}
