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
