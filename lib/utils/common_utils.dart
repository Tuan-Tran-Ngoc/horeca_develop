import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/extensions.dart';
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
    if (prefs.get(Session.refreshToken.toString()) != null) {
      refresh_token = prefs.get(Session.refreshToken.toString()).toString();
    }
    if (prefs.get(Session.languageCode.toString()) != null) {
      languageCode = prefs.get(Session.languageCode.toString()).toString();
    }
    await prefs.clear();
    if (refresh_token != null) {
      prefs.setString(Session.refreshToken.toString(), refresh_token);
    }
    if (languageCode != null) {
      prefs.setString(Session.languageCode.toString(), languageCode);
    }
    // emit(LogoutSuccessful());
  }

  static String formatQtyPercent(double value) {
    return NumberFormat('0.0%').format(value / 100);
  }

  static Future<bool> checkShiftForToday() async {
    late SharedPreferences prefs;
    bool result = true;
    prefs = await SharedPreferences.getInstance();
    String? workingDateStr = prefs.getString(Session.workingDate.toString());
    if (workingDateStr != null && workingDateStr != '') {
      try {
        DateFormat dateFormat = DateFormat(Constant.dateTimeFormatter);
        DateTime workingDate = dateFormat.parse(workingDateStr);
        DateTime now = DateTime.now();
        if (workingDate.isSameDate(now)) {
          result = true;
        } else {
          result = false;
        }
      } catch (error) {
        result = true;
      }
    }

    return result;
  }

  // static String formatNumber(double number) {
  //   // Chuyển đổi số thành chuỗi với định dạng cần thiết
  //   String formatted = NumberFormat('#,##0', 'fr_FR').format(number);

  //   // Thêm phần thập phân nếu có
  //   String decimalPart = (number % 1).toString(); // Lấy phần thập phân
  //   if (decimalPart != "0.0") {
  //     // Chỉ hiển thị phần thập phân nếu nó khác 0
  //     formatted += ',' +
  //         decimalPart
  //             .split('.')[1]
  //             .substring(0, 3); // Lấy tối đa 3 chữ số thập phân
  //   }

  //   return formatted;
  // }
  static String formatCurrency(double? value) {
    value ??= 0;
    if (value == value.toInt()) {
      return NumberFormat.currency(locale: 'vi').format(value.toInt());
    } else {
      return NumberFormat.currency(locale: 'vi').format(value.round());
    }
  }

  static String displayCurrency(double? value) {
    value ??= 0;
    if (value == value.toInt()) {
      return NumberFormat.currency(locale: 'vi').format(value.toInt());
    } else {
      return NumberFormat.currency(
              locale: 'vi', symbol: 'VND', decimalDigits: 3)
          .format(value);
    }
  }
}
