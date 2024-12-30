import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/api.dart' as api;

import 'log_record.dart';

abstract class ReadableLogRecord {
  sdk.Resource get resource;
  late final DateTime observedTimestamp;
  late final DateTime recordTime;
  late final Severity? severity;
  api.Attribute get body;
  sdk.Attributes get attributes;
  sdk.InstrumentationScope get instrumentationScope;
  api.SpanContext get spanContext;

  set attributes(sdk.Attributes attribute);
  set severity(Severity severity);
  set body();


  void setBody(api.Attribute attribute);
  void emit();

}