import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {
  static String convertDate(String? originalDateString, String formatter) {
    try {
      if (originalDateString == null || originalDateString.isEmpty) {
        return '';
      }
      DateTime? originalDate = DateTime.tryParse(originalDateString);
      String formattedDate = DateFormat(formatter).format(originalDate!);
      return formattedDate;
    } catch (error) {
      print('error CommonUtils convertDate $error');
    }

    return '';
  }

  static String firstLetterUpperCase(String str) {
    String result = "";
    String strClone = str;
    if (str.isNotEmpty) {
      str = str.toLowerCase();
      bool flagNewLine = false;
      bool flagDot = false;
      bool inQuote = false;
      for (int i = 0; i < str.length - 1; i++) {
        String char = str[i];
        String nextChar = str[i + 1];

        if (char == '"' || char == "'") {
          inQuote = !inQuote;
        }

        if (inQuote) {
          char = strClone[i];
        }

        if (char != ' ' && char != '' && char != '\n' && flagDot) {
          flagDot = false;
          char = char.toUpperCase();
        }
        if (char != ' ' && char != '' && char != '\n' && flagNewLine) {
          flagNewLine = false;
          char = char.toUpperCase();
        }
        if (char == '\n' && nextChar == ' ') {
          i++;
        }

        if (char == "\n" && nextChar != "." && nextChar != "\n") {
          flagNewLine = true;
        }
        if (char == "." && nextChar != ".") {
          flagDot = true;
        }
        if (i == 0) {
          char = char.toUpperCase();
        }
        result += char;
        if (char == '.' && nextChar != ' ') {
          result += " ";
        }
        if (i == str.length - 2) {
          result += nextChar;
        }
      }
    }
    return result;
  }

  static Future<void> logout() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String? refresh_token;
    String? languageCode;
    if (prefs.get('refresh_token') != null) {
      refresh_token = prefs.get('refresh_token').toString();
    }
    if (prefs.get('languageCode') != null) {
      languageCode = prefs.get('languageCode').toString();
    }
    await prefs.clear();
    if (refresh_token != null) prefs.setString('refresh_token', refresh_token);
    if (languageCode != null) prefs.setString('languageCode', languageCode);
    // emit(LogoutSuccessful());
  }
}
