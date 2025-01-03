import 'package:opentelemetry/src/experimental_sdk.dart';

abstract class LogRecordProcessor {
  void onEmit(LogRecord logRecord);

  Future<void> forceFlush();

  Future<void> shutdown();
}
