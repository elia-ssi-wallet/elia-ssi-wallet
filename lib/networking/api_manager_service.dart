// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:retrofit/http.dart';

part 'api_manager_service.g.dart';

@RestApi()
//! flutter pub run build_runner watch --delete-conflicting-outputs
abstract class ApiManagerService {
  factory ApiManagerService(Dio dio, {String baseUrl}) = _ApiManagerService;

  //* Create a DID
  @POST("https://vc-api-dev.energyweb.org/v1/did")
  Future<dynamic> createDID({@Body() required dynamic body});

  //* Export key
  @GET("https://vc-api-dev.energyweb.org/v1/key/{keyId}")
  Future<dynamic> exportKey({@Path("keyId") required String keyId});

  //* Import key
  @POST("https://vc-api-dev.energyweb.org/v1/key")
  Future<dynamic> importKey({@Body() required dynamic body});

  //* Register DID
  @POST("https://vc-api-dev.energyweb.org/v1/did")
  Future<dynamic> registerDID({@Body() required dynamic body});

  //* CHECK IF DID EXISTS
  @GET("https://vc-api-dev.energyweb.org/v1/did/{myDID}")
  Future<dynamic> checkIfDIDExists({@Path("myDID") required String did});

  //* 1.6 [Resident] Continue exchange by submitting the DID Auth proof
  //* 1.12 [Resident] Continue the exchange and obtain the credentials
  // @PUT("https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/{exchangeId}/{transactionId}")
  @PUT("{serviceEndpoint}")
  Future<dynamic> continueExchangeWithDIDAuthProof({
    // @Path("exchangeId") required String exchangeId,
    // @Path("transactionId") required String transactionId,
    @Path("serviceEndpoint") required String serviceEndpoint,
    @Body() required dynamic vpRequest,
  });

  //* 1.3 [Resident] Initiate issuance exchange using the request URL
  @POST("{exchangeURL}")
  Future<dynamic> initiateIssuance({@Path("exchangeURL") required String exchangeURL});

  //* 1.5 [Resident] Create a DID authentication proof
  @POST("https://vc-api-dev.energyweb.org/v1/vc-api/presentations/prove/authentication")
  Future<dynamic> createDidAuthenticationProof({
    @Body() required dynamic body,
  });
}

// {"outOfBandInvitation": { "type": "https://energyweb.org/out-of-band-invitation/vc-api-exchange","body": { "credentialTypeAvailable": "PermanentResidentCard","url": "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test2"}}}
