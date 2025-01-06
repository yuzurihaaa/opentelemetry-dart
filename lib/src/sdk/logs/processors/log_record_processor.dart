import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;

abstract class LogRecordProcessor {
  void onEmit(sdk.LogRecord logRecord);

  Future<void> forceFlush();

  Future<void> shutdown();
}
