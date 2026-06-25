import 'package:boveda_personal/core/ports/app_metadata_provider.dart';

class GetAppMetadata {
  const GetAppMetadata(this.provider);
  final AppMetadataProvider provider;

  Future<AppMetadata> call() => provider.load();
}
