import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart';

abstract class ReadableLogRecord {
  Int64? get hrTime;

  Int64? get hrTimeObserved;

  api.SpanContext? get spanContext;

  String? get severityText;

  set severityText(String? severity);

  Severity? get severityNumber;

  set severityNumber(Severity? severity);

  dynamic get body;

  set body(dynamic severity);

  sdk.Resource? get resource;

  sdk.InstrumentationScope? get instrumentationScope;

  sdk.Attributes? get attributes;

  int get droppedAttributesCount;
}