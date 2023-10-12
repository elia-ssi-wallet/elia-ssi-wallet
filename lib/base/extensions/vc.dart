
extension VcTableTypeExtension on VC {
  String vcTableType() {
    List<String> types = this.types;

    if (types.length > 1) {
      types.removeWhere((element) => element == "VerifiableCredential");

      return types.join(', ');
    } else {
      return types.first;
    }
  }
}

extension VcTypeExtension on List<String> {
  String vcType() {
    if (length > 1) {
      removeWhere((element) => element == "VerifiableCredential");

      return join(', ');
    } else {
      return first;
    }
  }
}
