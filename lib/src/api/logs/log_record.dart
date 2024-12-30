import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart';

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

class LogRecord {
  final Severity? severityNumber;
  final Int64? timeStampt;
  final Int64? observedTimestamp;
  final String severityText;
  final dynamic logBody;
  final List<Attribute> attributes;
  final Context? context;

  LogRecord({
    required this.severityNumber,
    required this.timeStampt,
    required this.observedTimestamp,
    required this.severityText,
    required this.logBody,
    required this.attributes,
    required this.context,
  });
}
