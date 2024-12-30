import 'log_provider.dart';

abstract class Logger {
  void emit(LogRecord logRecord);
}