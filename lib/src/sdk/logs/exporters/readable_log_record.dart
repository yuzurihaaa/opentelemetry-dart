import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart';

abstract class ReadableLogRecord {
  DateTime get hrTime;

  DateTime get hrTimeObserved;

  api.SpanContext? get spanContext;

  String? get severityText;

  Severity? get severityNumber;

  dynamic get body;

  sdk.Resource get resource;

  sdk.InstrumentationScope get instrumentationScope;

  api.Attribute get attributes;

  int get droppedAttributesCount;
}
