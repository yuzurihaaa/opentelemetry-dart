import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';

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
    Attributes? attributes,
    Context? context,
    dynamic logBody,
    Int64? observedTimestamp,
    Severity? severityNumber,
    String? severityText,
    Int64? timeStamp,
  }) =>
      _LogRecord(
        attributes: attributes,
        severityText: severityText,
        context: context,
        logBody: logBody,
        observedTimestamp: observedTimestamp,
        severityNumber: severityNumber,
        timeStamp: timeStamp,
      );

  Int64? get timeStamp;

  Int64? get observedTimestamp;

  Severity? get severityNumber;

  String? get severityText;

  dynamic get logBody;

  Attributes? get attributes;

  Context? get context;
}

class _LogRecord implements LogRecord {
  @override
  final Attributes? attributes;

  @override
  final Context? context;

  @override
  final dynamic logBody;

  @override
  final Int64? observedTimestamp;

  @override
  final Severity? severityNumber;

  @override
  final String? severityText;

  @override
  final Int64? timeStamp;

  const _LogRecord({
    this.attributes,
    this.severityText,
    this.context,
    this.logBody,
    this.observedTimestamp,
    this.severityNumber,
    this.timeStamp,
  });
}
