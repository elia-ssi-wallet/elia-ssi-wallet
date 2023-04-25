// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_manager_service.g.dart';

@RestApi()
//! flutter pub run build_runner watch --delete-conflicting-outputs
abstract class ApiManagerService {
  factory ApiManagerService(Dio dio, {String baseUrl}) = _ApiManagerService;

  //* CREATE A DID
  @POST("https://vc-api-dev.energyweb.org/v1/did")
  Future<dynamic> createDID({@Body() required dynamic body});

  //* EXPORT KEY
  @GET("https://vc-api-dev.energyweb.org/v1/key/{keyId}")
  Future<dynamic> exportKey({@Path("keyId") required String keyId});

  //* IMPORT KEY
  @POST("https://vc-api-dev.energyweb.org/v1/key")
  Future<dynamic> importKey({@Body() required dynamic body});

  //* REGISTER DID
  @POST("https://vc-api-dev.energyweb.org/v1/did")
  Future<dynamic> registerDID({@Body() required dynamic body});

  //* CHECK IF DID EXISTS
  @GET("https://vc-api-dev.energyweb.org/v1/did/{myDID}")
  Future<dynamic> checkIfDIDExists({@Path("myDID") required String did});

  //* INITIATE ISSUANCE
  @POST("{exchangeURL}")
  Future<dynamic> initiateIssuance({
    @Path("exchangeURL") required String exchangeURL,
  });

  //* CREATE DID AUTHENTICATION PROOF
  @POST("{baseUrl}/v1/vc-api/presentations/prove/authentication")
  Future<dynamic> createDidAuthenticationProof({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic body,
  });

  //* CREATE PRESENTATION
  @POST("{baseUrl}/v1/vc-api/presentations/prove")
  Future<dynamic> createPresentation({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic presentation,
  });

  //* SUBMIT PROOF
  @PUT("{serviceEndpoint}")
  Future<dynamic> submitProof({
    @Path("serviceEndpoint") required String serviceEndpoint,
    @Body() required dynamic vpRequest,
  });

  //* CONVERT INPUT DESCRIPTOR TO CREDENTIAL
  @POST("{idcUrl}/converter/input-descriptor-to-credential")
  Future<dynamic> convertInputDescriptorToCredential({
    @Path("idcUrl") required String idcUrl,
    @Body() required dynamic inputDescriptor,
  });

  //* ISSUE SELF-SIGNED CREDENTIAL
  @POST("{baseUrl}/v1/vc-api/credentials/issue")
  Future<dynamic> issueSelfSignedContract({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic credential,
  });

  //* FOR UNIT TESTS
  @POST("{baseUrl}/exchanges")
  Future<dynamic> configureExchange({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic exchangeDefinitions,
  });

  @POST("{baseUrl}/credentials/issue")
  Future<dynamic> issueVC({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic vc,
  });

  @POST("{baseUrl}/presentations/prove")
  Future<dynamic> wrapVcInVp({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic vp,
  });

  @POST("{baseUrl}/exchanges/{exchangeId}/{transactionId}/review")
  Future<dynamic> reviewExchange({
    @Path("baseUrl") required String baseUrl,
    @Path("exchangeId") required String exchangeId,
    @Path("transactionId") required String transactionId,
    @Body() required dynamic vp,
  });
}

// {"outOfBandInvitation": { "type": "https://energyweb.org/out-of-band-invitation/vc-api-exchange","body": { "credentialTypeAvailable": "PermanentResidentCard","url": "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test2"}}}
