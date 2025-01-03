import 'package:meta/meta.dart';
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart';

/// This class can be used for testing purposes. It stores the exported LogRecords
/// in a list in memory that can be retrieved using the `getFinishedLogRecords()`
/// method.
class InMemoryLogRecordExporter implements LogRecordExporter {
  var _finishedLogRecords = <ReadableLogRecord>[];

  /// Indicates if the exporter has been "shutdown."
  /// When false, exported log records will not be stored in-memory.
  @protected
  bool _stopped = false;

  @override
  Future<api.ExportResult> export(List<ReadableLogRecord> logs) async {
    if (_stopped) {
      return api.ExportResult(
        code: api.ExportResultCode.failed,
        error: Exception('Exporter has been stopped'),
        stackTrace: StackTrace.current,
      );
    }
    _finishedLogRecords.addAll(logs);

    return api.ExportResult(code: api.ExportResultCode.success);
  }

  @override
  Future<void> shutdown() async {
    _stopped = true;
    reset();
  }

  List<ReadableLogRecord> get finishedLogRecords => List.unmodifiable(_finishedLogRecords);

  void reset() {
    _finishedLogRecords = <ReadableLogRecord>[];
  }
}
