// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

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

  //* 1.3 [Resident] Initiate issuance exchange using the request URL
  @POST("{exchangeURL}")
  Future<dynamic> initiateIssuance({
    @Path("exchangeURL") required String exchangeURL,
  });

  //* 1.5 [Resident] Create a DID authentication proof
  @POST("{baseUrl}/presentations/prove/authentication")
  Future<dynamic> createDidAuthenticationProof({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic body,
  });

  //* 1.6 [Resident] Continue exchange by submitting the DID Auth proof
  //* 1.12 [Resident] Continue the exchange and obtain the credentials
  @PUT("{serviceEndpoint}")
  Future<dynamic> continueExchangeWithDIDAuthProof({
    @Path("serviceEndpoint") required String serviceEndpoint,
    @Body() required dynamic vpRequest,
  });

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

  //! -------------------- BEGIN CONSENT --------------------

  //* 3 [Consenter] Initiate issuance exchange using the request URL
  @POST("{urlEndPoint}")
  Future<dynamic> initiateConsentIssuance({
    @Path("urlEndPoint") required String endpoint,
  });

  //* 5 [Consenter] Convert the input descriptor to a credential
  @POST("{idcUrl}/converter/input-descriptor-to-credential")
  Future<dynamic> convertInputDescriptorToCredential({
    @Path("idcUrl") required String idcUrl,
    @Body() required dynamic inputDescriptor,
  });

  //* 6 [Consenter] Issue a self-signed credential
  @POST("{baseUrl}/v1/vc-api/credentials/issue")
  Future<dynamic> issueSelfSignedContract({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic credential,
  });

  //* 7 [Consenter] Create a presentation with the self-signed credential
  @POST("{baseUrl}/v1/vc-api/presentations/prove")
  Future<dynamic> createPresentationWithSelfSignedCredential({
    @Path("baseUrl") required String baseUrl,
    @Body() required dynamic presentation,
  });

  //* 8 [Consenter] Continue exchange by submitting the presentation
  @PUT("{endpoint}")
  Future<dynamic> continueExchangeBySubmitting({
    @Path("endpoint") required String endpoint,
    @Body() required dynamic presentationWithCredential,
  });

  //! -------------------- END CONSENT --------------------
}

// {"outOfBandInvitation": { "type": "https://energyweb.org/out-of-band-invitation/vc-api-exchange","body": { "credentialTypeAvailable": "PermanentResidentCard","url": "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test2"}}}
