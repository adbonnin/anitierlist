extension StringExtension on String {
  String removeSpecialCharacters() {
    return replaceSpecialCharacters('');
  }

  String replaceSpecialCharacters(String replace) {
    return replaceAll(RegExp(r'[^a-zA-ZÀ-ÖØ-öø-ÿ0-9\s]+'), replace);
  }

  String removeMultipleSpace() {
    return replaceAll(RegExp(' +'), ' ');
  }
}
