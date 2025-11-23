import 'package:format/format.dart';
import 'package:horeca/language_setting.dart';
import 'package:horeca_service/horeca_service.dart';

class MessageUtils {
  static List<Messages>? _messages;
  static bool _isLoaded = false;

  static Future<void> loadMessagesIfNeeded() async {
    if (!_isLoaded) {
      await _loadMessages();
      _isLoaded = true;
    }
  }

  static Future<void> _loadMessages() async {
    MessagesProvider messagesProvider = MessagesProvider();
    _messages = await messagesProvider.select();
  }

  static String? getMessage(String? messageCode) {
    if (_messages == null) {
      throw Exception(
          "Messages have not been loaded yet. Please call loadMessagesIfNeeded() first.");
    }

    Messages record = _messages!.firstWhere(
      (element) =>
          element.messageCode == messageCode &&
          element.languageCode == LanguageSetting.locale.languageCode,
      orElse: () => Messages(),
    );

    return record.messageString;
  }

  static String getMessages({required String? code, List<String>? args}) {
    if (_messages == null) {
      throw Exception(
          "Messages have not been loaded yet. Please call loadMessagesIfNeeded() first.");
    }

    String? mess = getMessage(code);
    List<String> parameters = [];
    if (args != null && args.isNotEmpty) {
      for (String argCode in args) {
        parameters.add(getMessage(argCode) ?? argCode);
      }
    }

    return format(mess!, parameters);
  }
}
