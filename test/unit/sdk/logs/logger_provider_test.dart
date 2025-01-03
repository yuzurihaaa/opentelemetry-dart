import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/api/logs/log_record.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/console_log_record_exporter.dart';
import 'package:opentelemetry/src/sdk/logs/logger_provider.dart';
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
        .emit(LogRecord(logBody: 'TESTTT!!!', context: context, severityNumber: Severity.FATAL4));

    await Future.delayed(const Duration(seconds: 1));
  });
}
