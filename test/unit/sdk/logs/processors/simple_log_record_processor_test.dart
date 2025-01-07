// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

@TestOn('vm')
import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/api/common/export_result.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/src/sdk/logs/processors/simple_log_record_processor.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';

void main() {
  late sdk.LogRecordExporter exporter;
  late sdk.LogRecordProcessor processor;

  setUp(() {
    exporter = MockLogRecordExporter();
    processor = SimpleLogRecordProcessor(exporter: exporter);
    when(() => exporter.export(any())).thenAnswer((_) async => ExportResult(code: ExportResultCode.success));
    when(() => exporter.shutdown()).thenAnswer((_) => Future.value());
  });

  test('executes export', () {
    final logRecord = sdk.LogRecord(
      instrumentationScope: sdk.InstrumentationScope('library_name', 'library_version', 'url://schema', []),
      logRecord: api.LogRecord(),
      logRecordLimits: sdk.LogRecordLimits(),
    );

    processor.onEmit(logRecord);

    verify(() => exporter.export([logRecord])).called(1);
  });

  test('executes export and fail', () async {
    var errorMessage = '';
    Logger.root.onRecord.listen((data) {
      errorMessage = data.message;
    });
    final logRecord = sdk.LogRecord(
      instrumentationScope: sdk.InstrumentationScope('library_name', 'library_version', 'url://schema', []),
      logRecord: api.LogRecord(),
      logRecordLimits: sdk.LogRecordLimits(),
    );

    when(() => exporter.export(any())).thenAnswer((_) async => ExportResult(code: ExportResultCode.failed));

    processor.onEmit(logRecord);

    await Future.delayed(const Duration(milliseconds: 50));

    expect(errorMessage, 'SimpleLogRecordProcessor: log record export failed');
  });

  test('shutdown exporters on forced flush', () async {
    await processor.shutdown();

    verify(exporter.shutdown).called(1);
  });

  test('forceFlush waits for all pending exports to complete', () async {
    when(() => exporter.export(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return ExportResult(code: ExportResultCode.success);
    });

    // Emit two log records, creating two pending exports.
    processor.onEmit(
      sdk.LogRecord(
          instrumentationScope: sdk.InstrumentationScope('library_name', 'library_version', 'url://schema', []),
          logRecord: api.LogRecord(),
          logRecordLimits: sdk.LogRecordLimits(),
          timeProvider: FakeTimeProvider(now: Int64(123))),
    );
    await Future.delayed(Duration(milliseconds: 50));
    processor.onEmit(
      sdk.LogRecord(
          instrumentationScope: sdk.InstrumentationScope('library_name', 'library_version', 'url://schema', []),
          logRecord: api.LogRecord(),
          logRecordLimits: sdk.LogRecordLimits(),
          timeProvider: FakeTimeProvider(now: Int64(123))),
    );
    expect((processor as SimpleLogRecordProcessor).exportsCompletion.length, 2);
    // Ensure the exports are pending.
    final flushFuture = processor.forceFlush();
    expect(flushFuture, completes);
  });
}