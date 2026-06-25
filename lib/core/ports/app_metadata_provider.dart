class AppMetadata {
  const AppMetadata({
    required this.name,
    required this.version,
    required this.buildNumber,
  });

  final String name;
  final String version;
  final String buildNumber;
}

abstract interface class AppMetadataProvider {
  Future<AppMetadata> load();
}
