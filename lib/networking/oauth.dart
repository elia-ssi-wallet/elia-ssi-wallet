// import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'oauth.g.dart';

@JsonSerializable()
class OAuthToken {
  @JsonKey(name: "token_type")
  String tokenType;
  @JsonKey(name: "expires_in")
  double expiresIn;
  @JsonKey(name: "access_token")
  String accessToken;
  @JsonKey(name: "refresh_token")
  String refreshToken;

  OAuthToken({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory OAuthToken.fromJson(Map<String, dynamic> json) => _$OAuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthTokenToJson(this);

  @override
  String toString() {
    return 'OAuthToken(tokenType: $tokenType, expiresIn: $expiresIn, accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

// class OAuthToken {
//   String tokenType;
//   int expiresIn;
//   String accessToken;

//   OAuthToken({
//     required this.tokenType,
//     required this.expiresIn,
//     required this.accessToken,
//   });

//   @override
//   String toString() =>
//       'OAuthToken(tokenType: $tokenType, expiresIn: $expiresIn, accessToken: $accessToken)';

//   Map<String, dynamic> toMap() {
//     return {
//       'tokenType': tokenType,
//       'expiresIn': expiresIn,
//       'accessToken': accessToken,
//     };
//   }

//   factory OAuthToken.fromMap(Map<String, dynamic> map) {
//     return OAuthToken(
//       tokenType: map['tokenType'],
//       expiresIn: map['expiresIn'],
//       accessToken: map['accessToken'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory OAuthToken.fromJson(String source) =>
//       OAuthToken.fromMap(json.decode(source));
// }
