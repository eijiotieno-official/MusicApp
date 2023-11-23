String formatTitle({required String title}) {
  String string = title;

  // Remove data within ()
  string = string.replaceAll(RegExp(r'\([^)]*\)'), '');

  // Remove data within []
  string = string.replaceAll(RegExp(r'\[[^\]]*\]'), '');

  // Remove file extension
  if (string.contains('.')) {
    string = string.split('.').first; // Remove everything after the first '.'
  }

  return string;
}
