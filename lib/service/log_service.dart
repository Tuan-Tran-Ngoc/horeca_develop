import 'package:logging/logging.dart';

class LogService {
  static late final Logger _log;

  static Logger get log => _log;

  static void initialize() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    _log = Logger('Acecook');
  }
}
