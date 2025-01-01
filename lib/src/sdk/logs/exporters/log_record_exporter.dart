import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/sdk/logs/exporters/readable_log_record.dart';

abstract class LogRecordExporter {
  void export(
    List<ReadableLogRecord> logs,
    void Function(api.ExportResult result) resultCallback,
  );

  Future<void> shutdown();
}
