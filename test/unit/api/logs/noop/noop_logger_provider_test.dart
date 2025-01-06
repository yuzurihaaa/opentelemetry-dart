// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

@TestOn('vm')
import 'package:opentelemetry/src/api/logs/noop/noop_logger.dart';
import 'package:opentelemetry/src/api/logs/noop/noop_logger_provider.dart';
import 'package:test/test.dart';

void main() {
  test('returns noop logger', () {
    final noopLoggerProvider = NoopLoggerProvider();
    expect(noopLoggerProvider.get('test'), const NoopLogger());
  });
}
