// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    NotFoundScreenRoute.name: (routeData) {
      final args = routeData.argsAs<NotFoundScreenRouteArgs>(
          orElse: () => const NotFoundScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotFoundScreen(
          key: args.key,
          error: args.error,
          errorMessage: args.errorMessage,
        ),
      );
    },
    AcceptTermsAndConditionsRoute.name: (routeData) {
      final args = routeData.argsAs<AcceptTermsAndConditionsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AcceptTermsAndConditions(
          key: args.key,
          onSuccess: args.onSuccess,
        ),
      );
    },
    TermsOfUseScreenRoute.name: (routeData) {
      final args = routeData.argsAs<TermsOfUseScreenRouteArgs>(
          orElse: () => const TermsOfUseScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TermsOfUseScreen(key: args.key),
      );
    },
    CompatibleContractsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<CompatibleContractsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompatibleContractsScreen(
          key: args.key,
          types: args.types,
          vCsList: args.vCsList,
        ),
      );
    },
    ConfirmContractRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmContractRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConfirmContract(
          key: args.key,
          vp: args.vp,
          pendingRequestId: args.pendingRequestId,
        ),
      );
    },
    ConsentScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ConsentScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConsentScreen(
          key: args.key,
          termsAndContitions: args.termsAndContitions,
        ),
      );
    },
    HomeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HomeScreenRouteArgs>(
          orElse: () => const HomeScreenRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeScreen(key: args.key),
      );
    },
    VCDetailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VCDetailScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: VCDetailScreen(
          vc: args.vc,
          key: args.key,
        ),
      );
    },
    LoadingScreenRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<LoadingScreenRouteArgs>(
          orElse: () => LoadingScreenRouteArgs(
                  url: queryParams.getString(
                'url',
                "",
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoadingScreen(
          key: args.key,
          url: args.url,
        ),
      );
    },
    QrCodeScannerRoute.name: (routeData) {
      final args = routeData.argsAs<QrCodeScannerRouteArgs>(
          orElse: () => const QrCodeScannerRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QrCodeScanner(key: args.key),
      );
    },
  };
}

/// generated route for
/// [NotFoundScreen]
class NotFoundScreenRoute extends PageRouteInfo<NotFoundScreenRouteArgs> {
  NotFoundScreenRoute({
    Key? key,
    bool error = true,
    String? errorMessage,
    List<PageRouteInfo>? children,
  }) : super(
          NotFoundScreenRoute.name,
          args: NotFoundScreenRouteArgs(
            key: key,
            error: error,
            errorMessage: errorMessage,
          ),
          initialChildren: children,
        );

  static const String name = 'NotFoundScreenRoute';

  static const PageInfo<NotFoundScreenRouteArgs> page =
      PageInfo<NotFoundScreenRouteArgs>(name);
}

class NotFoundScreenRouteArgs {
  const NotFoundScreenRouteArgs({
    this.key,
    this.error = true,
    this.errorMessage,
  });

  final Key? key;

  final bool error;

  final String? errorMessage;

  @override
  String toString() {
    return 'NotFoundScreenRouteArgs{key: $key, error: $error, errorMessage: $errorMessage}';
  }
}

/// generated route for
/// [AcceptTermsAndConditions]
class AcceptTermsAndConditionsRoute
    extends PageRouteInfo<AcceptTermsAndConditionsRouteArgs> {
  AcceptTermsAndConditionsRoute({
    Key? key,
    required dynamic Function(bool) onSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          AcceptTermsAndConditionsRoute.name,
          args: AcceptTermsAndConditionsRouteArgs(
            key: key,
            onSuccess: onSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'AcceptTermsAndConditionsRoute';

  static const PageInfo<AcceptTermsAndConditionsRouteArgs> page =
      PageInfo<AcceptTermsAndConditionsRouteArgs>(name);
}

class AcceptTermsAndConditionsRouteArgs {
  const AcceptTermsAndConditionsRouteArgs({
    this.key,
    required this.onSuccess,
  });

  final Key? key;

  final dynamic Function(bool) onSuccess;

  @override
  String toString() {
    return 'AcceptTermsAndConditionsRouteArgs{key: $key, onSuccess: $onSuccess}';
  }
}

/// generated route for
/// [TermsOfUseScreen]
class TermsOfUseScreenRoute extends PageRouteInfo<TermsOfUseScreenRouteArgs> {
  TermsOfUseScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          TermsOfUseScreenRoute.name,
          args: TermsOfUseScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'TermsOfUseScreenRoute';

  static const PageInfo<TermsOfUseScreenRouteArgs> page =
      PageInfo<TermsOfUseScreenRouteArgs>(name);
}

class TermsOfUseScreenRouteArgs {
  const TermsOfUseScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'TermsOfUseScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [CompatibleContractsScreen]
class CompatibleContractsScreenRoute
    extends PageRouteInfo<CompatibleContractsScreenRouteArgs> {
  CompatibleContractsScreenRoute({
    Key? key,
    required List<String> types,
    required List<dynamic> vCsList,
    List<PageRouteInfo>? children,
  }) : super(
          CompatibleContractsScreenRoute.name,
          args: CompatibleContractsScreenRouteArgs(
            key: key,
            types: types,
            vCsList: vCsList,
          ),
          initialChildren: children,
        );

  static const String name = 'CompatibleContractsScreenRoute';

  static const PageInfo<CompatibleContractsScreenRouteArgs> page =
      PageInfo<CompatibleContractsScreenRouteArgs>(name);
}

class CompatibleContractsScreenRouteArgs {
  const CompatibleContractsScreenRouteArgs({
    this.key,
    required this.types,
    required this.vCsList,
  });

  final Key? key;

  final List<String> types;

  final List<dynamic> vCsList;

  @override
  String toString() {
    return 'CompatibleContractsScreenRouteArgs{key: $key, types: $types, vCsList: $vCsList}';
  }
}

/// generated route for
/// [ConfirmContract]
class ConfirmContractRoute extends PageRouteInfo<ConfirmContractRouteArgs> {
  ConfirmContractRoute({
    Key? key,
    required dynamic vp,
    required int pendingRequestId,
    List<PageRouteInfo>? children,
  }) : super(
          ConfirmContractRoute.name,
          args: ConfirmContractRouteArgs(
            key: key,
            vp: vp,
            pendingRequestId: pendingRequestId,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmContractRoute';

  static const PageInfo<ConfirmContractRouteArgs> page =
      PageInfo<ConfirmContractRouteArgs>(name);
}

class ConfirmContractRouteArgs {
  const ConfirmContractRouteArgs({
    this.key,
    required this.vp,
    required this.pendingRequestId,
  });

  final Key? key;

  final dynamic vp;

  final int pendingRequestId;

  @override
  String toString() {
    return 'ConfirmContractRouteArgs{key: $key, vp: $vp, pendingRequestId: $pendingRequestId}';
  }
}

/// generated route for
/// [ConsentScreen]
class ConsentScreenRoute extends PageRouteInfo<ConsentScreenRouteArgs> {
  ConsentScreenRoute({
    Key? key,
    required String termsAndContitions,
    List<PageRouteInfo>? children,
  }) : super(
          ConsentScreenRoute.name,
          args: ConsentScreenRouteArgs(
            key: key,
            termsAndContitions: termsAndContitions,
          ),
          initialChildren: children,
        );

  static const String name = 'ConsentScreenRoute';

  static const PageInfo<ConsentScreenRouteArgs> page =
      PageInfo<ConsentScreenRouteArgs>(name);
}

class ConsentScreenRouteArgs {
  const ConsentScreenRouteArgs({
    this.key,
    required this.termsAndContitions,
  });

  final Key? key;

  final String termsAndContitions;

  @override
  String toString() {
    return 'ConsentScreenRouteArgs{key: $key, termsAndContitions: $termsAndContitions}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeScreenRoute.name,
          args: HomeScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const PageInfo<HomeScreenRouteArgs> page =
      PageInfo<HomeScreenRouteArgs>(name);
}

class HomeScreenRouteArgs {
  const HomeScreenRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [VCDetailScreen]
class VCDetailScreenRoute extends PageRouteInfo<VCDetailScreenRouteArgs> {
  VCDetailScreenRoute({
    required dynamic vc,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          VCDetailScreenRoute.name,
          args: VCDetailScreenRouteArgs(
            vc: vc,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VCDetailScreenRoute';

  static const PageInfo<VCDetailScreenRouteArgs> page =
      PageInfo<VCDetailScreenRouteArgs>(name);
}

class VCDetailScreenRouteArgs {
  const VCDetailScreenRouteArgs({
    required this.vc,
    this.key,
  });

  final dynamic vc;

  final Key? key;

  @override
  String toString() {
    return 'VCDetailScreenRouteArgs{vc: $vc, key: $key}';
  }
}

/// generated route for
/// [LoadingScreen]
class LoadingScreenRoute extends PageRouteInfo<LoadingScreenRouteArgs> {
  LoadingScreenRoute({
    Key? key,
    String url = "",
    List<PageRouteInfo>? children,
  }) : super(
          LoadingScreenRoute.name,
          args: LoadingScreenRouteArgs(
            key: key,
            url: url,
          ),
          rawQueryParams: {'url': url},
          initialChildren: children,
        );

  static const String name = 'LoadingScreenRoute';

  static const PageInfo<LoadingScreenRouteArgs> page =
      PageInfo<LoadingScreenRouteArgs>(name);
}

class LoadingScreenRouteArgs {
  const LoadingScreenRouteArgs({
    this.key,
    this.url = "",
  });

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'LoadingScreenRouteArgs{key: $key, url: $url}';
  }
}

/// generated route for
/// [QrCodeScanner]
class QrCodeScannerRoute extends PageRouteInfo<QrCodeScannerRouteArgs> {
  QrCodeScannerRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          QrCodeScannerRoute.name,
          args: QrCodeScannerRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'QrCodeScannerRoute';

  static const PageInfo<QrCodeScannerRouteArgs> page =
      PageInfo<QrCodeScannerRouteArgs>(name);
}

class QrCodeScannerRouteArgs {
  const QrCodeScannerRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'QrCodeScannerRouteArgs{key: $key}';
  }
}
