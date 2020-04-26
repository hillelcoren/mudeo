String toSnakeCase(String value) {
  value ??= '';
  return value.replaceAllMapped(
      RegExp(r'[A-Z]'), (Match match) => '_' + match[0].toLowerCase());
}

String formatLinkForHuman(String url) {
  if (url.startsWith('http://')) {
    return url.replaceFirst('http://', '');
  } else if (url.startsWith('https://')) {
    return url.replaceFirst('https://', '');
  } else {
    return url;
  }
}

String formatLinkForBrowser(String url) {
  if (! url.startsWith('http://') && ! url.startsWith('https://') ) {
    return 'http://$url';
  } else {
    return url;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}