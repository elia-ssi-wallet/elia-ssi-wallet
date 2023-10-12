import 'dart:convert';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/database/dao/all_daos.dart';
import 'package:elia_ssi_wallet/database/mobile.dart';
import 'package:elia_ssi_wallet/firebase_options.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'app.dart';

//! deeplink = elia-wallet://exchange/loading/testing1234 (testing1234 is url)
//! test deeplink iOS simulator => xcrun simctl openurl booted elia-wallet://exchange/loading/testing1234

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //on iOS after full screen splash notification bar is not automatically set again
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // String initialRoute = Routes.acceptTermsAndConditions;
  String initialRoute = "/";

  if (!kDebugMode) {
    await initSentry();
  }

  registerSingletons();

  database = constructDb();

  clearSecureStorageOnReinstall();

  preCacheImages();

  try {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Logger().d("FIREBASE APP = $firebaseApp");
  } on Exception catch (e) {
    Logger().e("Firebase initialization error: $e");
  }

  try {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Logger().d("FCM TOKEN = $fcmToken");

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    Logger().d("settings = $settings");
  } catch (e, stackTrace) {
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  String? deepLink = await handleDeepLink();

  if (deepLink != null) {
    Logger().d("SET DEEPLINK => $deepLink");
    initialRoute = deepLink;
  }

  await setupInteractedMessage();

  Logger().d("deep link function");

  uriLinkStream.listen(
    (Uri? link) {
      Logger().d("deep link -> $link");
      parseLink(link: link);
    },
    onError: (err) {
      locator.get<NavigationService>().router.push(NotFoundScreenRoute());
    },
  );

  runApp(App(initialRoute: initialRoute));

  FlutterNativeSplash.remove();
}

Future<String?> handleDeepLink() async {
  String? deeplink;
  try {
    final initialLink = await getInitialUri();
    Logger().d("initial deep link -> $initialLink");

    if (initialLink == null) {
      return null;
    } else {
      deeplink = parseInitalLink(link: initialLink);
    }
  } on PlatformException {
    return null;
  }
  return deeplink;
}

preCacheImages() async {
  await Future.wait([
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder,
        AppAssets.scanIcon,
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder,
        AppAssets.noContractIcon,
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder,
        AppAssets.notificationIcon,
      ),
      null,
    ),
  ]);
}

// It is assumed that all messages contain a data field with the key 'type'
Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) async {
  Logger().d('Message clicked ${message.data.toString()}!');

  String? exchangeId = message.data['exchangeId'];

  if (exchangeId != null) {
    Logger().d('Got exchangeID -> $exchangeId');

    PendingRequest? request = await PendingRequestsDao(database).getPendingRequestsWithExchangeId(exchangeId: exchangeId);

    if (request != null) {
      await ExchangeRepository.submitPresentation(
        serviceEndpoint: request.serviceEndpoint,
        vpRequest: jsonDecode(request.requestVp),
        onSuccess: (response) async {
          if (response['processingInProgress'] == false) {
            await ExchangeRepository.pendingRequestDao.updatePendingRequest(id: request.id, vp: response['vp']);
            // if (request.vp != null) {
            // Logger().d('Got pending request -> $request');
            Logger().d("navigate to confirm contract");
            locator.get<NavigationService>().router.push(ConfirmContractRoute(vp: response['vp'], pendingRequestId: request.id));
            // }
          }
        },
        onError: (e) async {
          Logger().e("onerror $e");
          await ExchangeRepository.pendingRequestDao.updatePendingRequestWithError(id: request.id);
        },
        showDialogs: false,
      );
    }
  }
}


// xcrun simctl openurl booted elia-wallet://exchange/loading?param={"outOfBandInvitation":{"type":"https://energyweb.org/out-of-band-invitation/vc-api-exchange","body":{"credentialTypeAvailable":"PermanentResidentCard","url":"https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test48"}}}