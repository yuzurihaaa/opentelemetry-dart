import 'package:opentelemetry/src/api/logs/log_record.dart';

import './log_record_processor.dart';

class NoopLogRecordProcessor implements LogRecordProcessor {
  @override
  Future<void> forceFlush() async {}

  @override
  void onEmit(LogRecord logRecord) {
    // TODO: implement onEmit
  }

  @override
  Future<void> shutdown() async {}
}
