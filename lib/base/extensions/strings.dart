extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }

  String prettifyDomain() {
    Uri uri = Uri.parse(this);
    return uri.host;
  }

  String getBaseUrlfromExchangeUrl() {
    return replaceRange(indexOf('/exchanges'), null, '');
  }
}
