// ignore_for_file: constant_identifier_names

enum Flavor {
  DEVELOPMENT,
  STAGING,
  QA,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return '';
      case Flavor.STAGING:
        return '';
      case Flavor.QA:
        return '';
      case Flavor.PRODUCTION:
        return '';
      default:
        return '';
    }
  }

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'Elia SSI Wallet';
      case Flavor.STAGING:
        return 'Elia SSI Wallet';
      case Flavor.QA:
        return 'Elia SSI Wallet';
      case Flavor.PRODUCTION:
        return 'Elia SSI Wallet';
      default:
        return 'title';
    }
  }
}
