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
