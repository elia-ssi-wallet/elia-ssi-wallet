// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  STAGING,
  QA,
  PROD,
}

class F {
  static Flavor? appFlavor;

  static String get onesignalKey {
    switch (appFlavor) {
      case Flavor.DEV:
        return '';
      case Flavor.STAGING:
        return '';
      case Flavor.QA:
        return '';
      case Flavor.PROD:
        return '';
      default:
        return '';
    }
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return '';
      case Flavor.STAGING:
        return '';
      case Flavor.QA:
        return '';
      case Flavor.PROD:
        return '';
      default:
        return '';
    }
  }

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Elia SSI Wallet';
      case Flavor.STAGING:
        return 'Elia SSI Wallet';
      case Flavor.QA:
        return 'Elia SSI Wallet';
      case Flavor.PROD:
        return 'Elia SSI Wallet';
      default:
        return 'title';
    }
  }
}
