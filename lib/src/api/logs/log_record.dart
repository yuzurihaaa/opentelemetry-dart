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

abstract class LogRecord {
  Severity? get severityNumber;
  Int64? get timeStamp;
  Int64? get observedTimestamp;
  String get severityText;
  dynamic get logBody;
  List<Attribute> get attributes;
  Context? get context;
}
