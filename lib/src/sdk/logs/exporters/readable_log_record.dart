import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart';

abstract class ReadableLogRecord {
  Int64? get hrTime;

  Int64? get hrTimeObserved;

  api.Context? get context;

  String? get severityText;

  Severity? get severityNumber;

  dynamic get body;

  sdk.Resource? get resource;

  sdk.InstrumentationScope? get instrumentationScope;

  sdk.Attributes? get attributes;

  int get droppedAttributesCount;
}

class _ReadableLogRecord implements ReadableLogRecord {
  @override
  final Int64? hrTime;

  @override
  final Int64? hrTimeObserved;

  @override
  final api.Context? context;

  @override
  final String? severityText;

  @override
  final Severity? severityNumber;

  @override
  final dynamic body;

  @override
  final sdk.Resource? resource;

  @override
  final sdk.InstrumentationScope? instrumentationScope;

  @override
  final sdk.Attributes? attributes;

  @override
  final int droppedAttributesCount;

  _ReadableLogRecord({
    this.hrTime,
    this.hrTimeObserved,
    this.context,
    this.severityText,
    this.severityNumber,
    this.body,
    this.resource,
    this.instrumentationScope,
    this.attributes,
    this.droppedAttributesCount = 0,
  });
}
