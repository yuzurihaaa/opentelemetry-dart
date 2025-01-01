import 'log_record.dart';

abstract class Logger {
  void emit(LogRecord logRecord);
}