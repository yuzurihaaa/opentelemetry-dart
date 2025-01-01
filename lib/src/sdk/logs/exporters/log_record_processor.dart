import 'package:opentelemetry/src/experimental_api.dart';

abstract class LogRecordProcessor {
  void onEmit(LogRecord logRecord);

  Future<void> forceFlush();

  Future<void> shutdown();
}
