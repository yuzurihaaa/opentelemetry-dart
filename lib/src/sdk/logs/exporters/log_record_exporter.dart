import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart';

abstract class LogRecordExporter {
  Future<api.ExportResult> export(List<ReadableLogRecord> logs);

  Future<void> shutdown();
}
