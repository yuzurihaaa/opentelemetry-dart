import 'package:opentelemetry/src/api/logs/logger.dart';
import 'package:opentelemetry/src/api/logs/log_record.dart';

class NoopLogger implements Logger {
  @override
  void emit(LogRecord logRecord) {}
}
