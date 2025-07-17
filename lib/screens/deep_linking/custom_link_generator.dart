class LinkGenerator {
  String createCustomLink(String path, Map<String, dynamic> queryParams) {
    Uri uri = Uri(
      scheme: 'https',
      host: 'linkon.social',
      path: path,
      queryParameters: queryParams,
    );
    return uri.toString();
  }
}
