// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

@TestOn('vm')
import 'package:fixnum/src/int64.dart';
import 'package:mocktail/mocktail.dart';
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/src/sdk/logs/log_record_limit.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(sdk.LogRecord(
      instrumentationScope: sdk.InstrumentationScope('library_name', 'library_version', 'url://schema', []),
      logRecordLimits: LogRecordLimitsImpl(),
    ));
  });

  test('getLogger stores tracers by name', () {
    final provider = sdk.LoggerProvider();
    final fooTracer = provider.get('foo');
    final barTracer = provider.get('bar');
    final fooWithVersionTracer = provider.get('foo', version: '1.0');

    expect(fooTracer, allOf([isNot(barTracer), isNot(fooWithVersionTracer), same(provider.get('foo'))]));

    expect(provider.processors, isA<List<sdk.LogRecordProcessor>>());
  });

  test('tracerProvider custom span processors', () {
    final mockProcessor1 = MockLogRecordProcessor();
    final mockProcessor2 = MockLogRecordProcessor();
    final provider = sdk.LoggerProvider(processors: [mockProcessor1, mockProcessor2]);

    expect(provider.processors, [mockProcessor1, mockProcessor2]);
  });

  test('traceProvider custom timeProvider', () {
    final mockTimeProvider = FakeTimeProvider(now: Int64(123));
    final mockProcessor1 = MockLogRecordProcessor();
    final provider = sdk.LoggerProvider(timeProvider: mockTimeProvider, processors: [mockProcessor1]);
    provider.get('foo').emit();
    verify(() => mockProcessor1.onEmit(any(
      that: predicate((a) {
        if (a is! sdk.ReadWriteLogRecord) return false;
        return a.timeStamp == 123 && a.observedTimestamp == 123;
      }),
    ))).called(1);
  });

  test('loggerProvider force flushes all processors', () async {
    final mockProcessor1 = MockLogRecordProcessor();
    final mockProcessor2 = MockLogRecordProcessor();
    when(mockProcessor1.forceFlush).thenAnswer((_) async => Future.value());
    when(mockProcessor2.forceFlush).thenAnswer((_) async => Future.value());
    await sdk.LoggerProvider(processors: [mockProcessor1, mockProcessor2]).forceFlush();

    verify(mockProcessor1.forceFlush).called(1);
    verify(mockProcessor2.forceFlush).called(1);
  });

  test('loggerProvider shuts down all processors', () async {
    final mockProcessor1 = MockLogRecordProcessor();
    final mockProcessor2 = MockLogRecordProcessor();
    when(mockProcessor1.shutdown).thenAnswer((_) async => Future.value());
    when(mockProcessor2.shutdown).thenAnswer((_) async => Future.value());
    await sdk.LoggerProvider(processors: [mockProcessor1, mockProcessor2]).shutdown();

    verify(mockProcessor1.shutdown).called(1);
    verify(mockProcessor2.shutdown).called(1);
  });

  test('logger provider test add processor', () {
    final provider = sdk.LoggerProvider()
      ..addLogRecordProcessor(const sdk.NoopLogRecordProcessor())
      ..addLogRecordProcessor(const sdk.NoopLogRecordProcessor());

    expect(provider.processors.length, 2);
  });
}