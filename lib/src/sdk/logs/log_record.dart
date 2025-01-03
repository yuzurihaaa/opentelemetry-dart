import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/sdk.dart' as sdk;

class LogRecord implements sdk.ReadableLogRecord {
  @override
  final sdk.Attributes? attributes;

  @override
  final dynamic body;

  @override
  final int droppedAttributesCount;

  @override
  final Int64? hrTime;

  @override
  final Int64? hrTimeObserved;

  @override
  final sdk.InstrumentationScope instrumentationScope;

  @override
  final sdk.Resource resource;

  @override
  final api.Severity? severityNumber;

  @override
  final String? severityText;

  @override
  final api.Context? context;

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
