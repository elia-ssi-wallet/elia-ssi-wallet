extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }

  String prettifyDomain() {
    Uri uri = Uri.parse(this);
    return uri.host;
  }

  String getBaseUrlfromExchangeUrl() {
    return replaceRange(indexOf('/v1/vc-api/exchanges'), null, '');
  }

  String getExchangeIdFromExchangeUrl() {
    Uri url = Uri.parse(this);
    List<String> pathSegments = url.pathSegments;
    String resourceName = pathSegments[pathSegments.indexOf("exchanges") + 1];
    return resourceName;
  }
}
