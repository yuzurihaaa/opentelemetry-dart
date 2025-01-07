// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/api/logs/log_record.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/console_log_record_exporter.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/log_collector_exporter.dart';
import 'package:opentelemetry/src/sdk/logs/logger_provider.dart';
import 'package:opentelemetry/src/sdk/logs/processors/batch_log_record_processor.dart';
import 'package:opentelemetry/src/sdk/logs/processors/simple_log_record_processor.dart';
import 'package:test/test.dart';

void main() {
  test('Test logger provider', () async {
    final loggerProvider = LoggerProvider()
      ..addLogRecordProcessor(
        SimpleLogRecordProcessor(exporter: ConsoleLogRecordExporter()),
      );

    final tracer = TracerProviderBase().getTracer('test');
    final parent = tracer.startSpan('parent');
    final context = contextWithSpan(Context.current, parent);
    loggerProvider
        .get('Test Logger')
        .emit(LogRecord(body: 'TESTTT!!!', context: context, severityNumber: Severity.fatal4));

    await Future.delayed(const Duration(seconds: 1));
  });

  test('Test logger provider 2', () async {
    final loggerProvider = LoggerProvider()
      ..addLogRecordProcessor(
        BatchLogRecordProcessor(exporter: ConsoleLogRecordExporter()),
      );

    final tracer = TracerProviderBase().getTracer('test');
    final parent = tracer.startSpan('parent');
    final context = contextWithSpan(Context.current, parent);
    loggerProvider.get('Test Logger')
      ..emit(LogRecord(body: 'TESTTT!!!', context: context, severityNumber: Severity.fatal4))
      ..emit(LogRecord(body: 'TESTTT2!!!', context: context, severityNumber: Severity.fatal4));

    await Future.delayed(const Duration(seconds: 10));
  });

  test('Test log collector 3', () async {
    final loggerProvider = LoggerProvider(
      resource: Resource([
        Attribute.fromString('app', 'test'),
      ]),
    )
      ..addLogRecordProcessor(
        BatchLogRecordProcessor(
            exporter: LogCollectorExporter(
          Uri.parse('https://quickwit-indexer.feedme.farm:7280/api/v1/otlp/v1/logs'),
        )),
      );

    final tracer = TracerProviderBase().getTracer('test');
    final parent = tracer.startSpan('parent');
    final context = contextWithSpan(Context.current, parent);
    loggerProvider.get('Test Logger')
      ..emit(LogRecord(body: 'TESTTT!!!', context: context, severityNumber: Severity.fatal4))
      ..emit(LogRecord(body: 'TESTTT2!!!', context: context, severityNumber: Severity.fatal4));

    await Future.delayed(const Duration(seconds: 10));
  });
}
