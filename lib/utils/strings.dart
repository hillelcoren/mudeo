String toSnakeCase(String value) {
  value ??= '';
  return value.replaceAllMapped(
      RegExp(r'[A-Z]'), (Match match) => '_' + match[0].toLowerCase());
}
