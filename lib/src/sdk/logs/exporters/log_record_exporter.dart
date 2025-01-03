import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/sdk/logs/exporters/readable_log_record.dart';

abstract class LogRecordExporter {
  Future<api.ExportResult> export(List<ReadableLogRecord> logs);

  Future<void> shutdown();
}
