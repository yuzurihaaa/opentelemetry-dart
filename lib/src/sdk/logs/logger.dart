import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;

import 'log_record.dart';

class Logger extends api.Logger {
  final InstrumentationScope instrumentationScope;
  final TimeProvider _timeProvider;
  final Function(LogRecord)? onLogEmit;

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
      severityText: logRecord.severityText,
      context: context,
      body: logRecord.logBody,
      hrTimeObserved: logRecord.observedTimestamp,
      severityNumber: logRecord.severityNumber,
      hrTime: logRecord.timeStamp ?? _timeProvider.now,
      instrumentationScope: instrumentationScope,
      resource: Resource([]),
      droppedAttributesCount: 0,
    );
    onLogEmit?.call(log);
  }
}
