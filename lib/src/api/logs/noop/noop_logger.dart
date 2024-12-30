import 'package:opentelemetry/src/api/logs/log_provider.dart';

class NoopLogger implements Logger {
  @override
  void emit(LogRecord logRecord) {}
}
