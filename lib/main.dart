import 'package:opentelemetry/api.dart' as sdk;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart';

void main() async {
  final loggerProvider = sdk.LoggerProvider(
    resource: sdk.Resource([
      sdk.Attribute.fromString('service.name', 'example-service'),
    ]),
  )
    ..addLogRecordProcessor(
      sdk.BatchLogRecordProcessor(
        // exporter: sdk.ConsoleLogRecordExporter()),
          exporter: sdk.LogCollectorExporter(
            Uri.parse('http://localhost:4318/v1/logs'),
          )),
    );

  final tracer = sdk.TracerProviderBase().getTracer('test');
  final parent = tracer.startSpan('parent');
  final context = sdk.contextWithSpan(sdk.Context.current, parent);
  loggerProvider.get('Test Logger')
    ..emit(LogRecord(body: 'TESTTT!!!', context: context, severityNumber: Severity.FATAL4))
    ..emit(LogRecord(body: 'TESTTT2!!!', context: context, severityNumber: Severity.FATAL4));

  await loggerProvider.shutdown();
}