import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;

import 'log_record.dart';

class Logger extends api.Logger {
  final sdk.InstrumentationScope instrumentationScope;
  final sdk.TimeProvider _timeProvider;
  final Function(LogRecord)? onLogEmit;

  Logger({
    required this.instrumentationScope,
    this.onLogEmit,
    sdk.TimeProvider? timeProvider,
  }) : _timeProvider = timeProvider ?? sdk.DateTimeTimeProvider();

  @override
  void emit(api.LogRecord logRecord) {
    final context = logRecord.context ?? api.Context.current;
    final log = LogRecord(
      attributes: logRecord.attributes,
      severityText: logRecord.severityText,
      context: context,
      body: logRecord.logBody,
      hrTimeObserved: logRecord.observedTimestamp,
      severityNumber: logRecord.severityNumber,
      hrTime: logRecord.timeStamp ?? _timeProvider.now,
      instrumentationScope: instrumentationScope,
      logRecord: logRecord,
    );
    onLogEmit?.call(log);
    log.makeReadonly();
  }
}
