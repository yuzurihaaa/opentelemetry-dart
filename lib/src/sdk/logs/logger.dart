import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;

import 'log_record.dart';

class Logger extends api.Logger {
  final InstrumentationScope instrumentationScope;
  final TimeProvider _timeProvider;
  final Function(api.LogRecord)? onLogEmit;

  Logger({
    required this.instrumentationScope,
    this.onLogEmit,
    TimeProvider? timeProvider,
  }) : _timeProvider = timeProvider ?? DateTimeTimeProvider();

  @override
  void emit(api.LogRecord logRecord) {
    final context = logRecord.context ?? Context.current;
    final log = LogRecord(
      attributes: logRecord.attributes,
      context: context,
      severityText: logRecord.severityText,
      logBody: logRecord.logBody,
      observedTimestamp: logRecord.observedTimestamp,
      severityNumber: logRecord.severityNumber,
      timeStamp: logRecord.timeStamp ?? _timeProvider.now,
    );
    onLogEmit?.call(log);
  }
}
