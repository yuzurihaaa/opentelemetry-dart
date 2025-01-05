import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;

import 'log_record.dart';

class Logger extends api.Logger {
  final sdk.InstrumentationScope instrumentationScope;
  final sdk.Resource? resource;
  final Function(LogRecord)? onLogEmit;
  final sdk.LogRecordLimits logRecordLimits;

  Logger({
    required this.instrumentationScope,
    required this.logRecordLimits,
    this.onLogEmit,
    this.resource,
  });

  @override
  void emit(api.LogRecord logRecord) {
    final log = LogRecord(
      logRecordLimits: logRecordLimits,
      resource: resource,
      instrumentationScope: instrumentationScope,
      logRecord: logRecord,
      context: logRecord.context,
    );
    onLogEmit?.call(log);
    log.makeReadonly();
  }
}
