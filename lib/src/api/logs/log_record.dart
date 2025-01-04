import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;

enum Severity {
  UNSPECIFIED,
  TRACE,
  TRACE2,
  TRACE3,
  TRACE4,
  DEBUG,
  DEBUG2,
  DEBUG3,
  DEBUG4,
  INFO,
  INFO2,
  INFO3,
  INFO4,
  WARN,
  WARN2,
  WARN3,
  WARN4,
  ERROR,
  ERROR2,
  ERROR3,
  ERROR4,
  FATAL,
  FATAL2,
  FATAL3,
  FATAL4,
}

abstract class LogRecord {
  factory LogRecord({
    sdk.Attributes? attributes,
    api.Context? context,
    dynamic body,
    DateTime? observedTimestamp,
    Severity? severityNumber,
    String? severityText,
    DateTime? timeStamp,
  }) =>
      _LogRecord(
        attributes: attributes,
        severityText: severityText,
        context: context,
        body: body,
        observedTimestamp: observedTimestamp,
        severityNumber: severityNumber,
        timeStamp: timeStamp,
      );

  DateTime? get timeStamp;

  DateTime? get observedTimestamp;

  Severity? get severityNumber;

  String? get severityText;

  dynamic get body;

  sdk.Attributes get attributes;

  api.Context get context;
}

class _LogRecord implements LogRecord {
  @override
  final sdk.Attributes attributes;

  @override
  final api.Context context;

  @override
  final dynamic body;

  @override
  final DateTime? observedTimestamp;

  @override
  final Severity? severityNumber;

  @override
  final String? severityText;

  @override
  final DateTime? timeStamp;

  _LogRecord({
    this.severityText,
    this.body,
    this.observedTimestamp,
    this.severityNumber,
    this.timeStamp,
    sdk.Attributes? attributes,
    api.Context? context,
  })  : attributes = attributes ?? sdk.Attributes.empty(),
        context = context ?? api.Context.current;
}
