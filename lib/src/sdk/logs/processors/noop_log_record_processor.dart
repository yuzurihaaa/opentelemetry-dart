import 'package:opentelemetry/src/experimental_sdk.dart';

class NoopLogRecordProcessor implements LogRecordProcessor {
  const NoopLogRecordProcessor();

  @override
  Future<void> forceFlush() async {}

  @override
  void onEmit(LogRecord logRecord) {
    // TODO: implement onEmit
  }

  @override
  Future<void> shutdown() async {}
}
