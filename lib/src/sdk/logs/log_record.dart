import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/sdk/common/attributes.dart';
import 'package:opentelemetry/src/sdk/common/instrumentation_scope.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/readable_log_record.dart';
import 'package:opentelemetry/src/sdk/resource/resource.dart';

class LogRecord implements ReadableLogRecord {
  @override
  final Attributes? attributes;

  @override
  final dynamic body;

  @override
  final int droppedAttributesCount;

  @override
  final Int64? hrTime;

  @override
  final Int64? hrTimeObserved;

  @override
  final InstrumentationScope instrumentationScope;

  @override
  final Resource resource;

  @override
  final api.Severity? severityNumber;

  @override
  final String? severityText;

  @override
  final Context? context;

  LogRecord({
    required this.attributes,
    required this.droppedAttributesCount,
    required this.hrTime,
    required this.hrTimeObserved,
    required this.instrumentationScope,
    required this.resource,
    this.body,
    this.severityNumber,
    this.severityText,
    this.context,
  });
}
