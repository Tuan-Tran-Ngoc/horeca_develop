import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/horeca_service.dart';

class CodeListUtils {
  static List<Resource>? _resources;
  static bool _isLoaded = false;

  static Future<void> loadCodeListIfNeeded() async {
    if (!_isLoaded) {
      await _loadResource();
      _isLoaded = true;
    }
  }

  static Future<void> _loadResource() async {
    ResourceProvider resourceProvider = ResourceProvider();
    _resources = await resourceProvider.select();
  }

  static String? getMessage(String? categoryCd, String? resourceCd) {
    if (_resources == null) {
      throw Exception(
          "Messages have not been loaded yet. Please call loadCodeListIfNeeded() first.");
    }

    Resource record = _resources!.firstWhere(
      (element) =>
          element.categoryCd == categoryCd && element.resourceCd == resourceCd,
      orElse: () => Resource(),
    );

    return MessageUtils.getMessage(record.value1);
  }
}
