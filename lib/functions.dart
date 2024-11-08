String fileName(String unformattedPath) {
  final parts = unformattedPath.split('/');
  final name = parts.isNotEmpty ? parts.last : unformattedPath;
  return name.trim();
}

String cleanFileName(String unformattedPath) {
  final fullName = fileName(unformattedPath);
  final parts = fullName.split('.');
  final name = parts.isNotEmpty ? parts.first : fullName;
  return name.trim();
}
