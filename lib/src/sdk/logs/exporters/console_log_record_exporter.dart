import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/log_record_exporter.dart';
import 'package:opentelemetry/src/sdk/logs/exporters/readable_log_record.dart';

/// This is implementation of [LogRecordExporter] that prints LogRecords to the
/// console. This class can be used for diagnostic purposes.
///
/// NOTE: This [LogRecordExporter] is intended for diagnostics use only, output rendered to the console may change at any time.
class ConsoleLogRecordExporter implements LogRecordExporter {
  @override
  Future<ExportResult> export(List<ReadableLogRecord> logs) async {
    return _sendLogRecords(logs);
  }

  /// Shutdown the exporter.
  @override
  Future<void> shutdown() async {}

  /// Showing logs  in console
  ExportResult _sendLogRecords(List<ReadableLogRecord> logs) {
    for (final log in logs) {
      print(_makeObject(log));
    }
    return ExportResult(code: ExportResultCode.success);
  }

  /// converts logRecord info into more readable format
  Map<String, dynamic> _makeObject(ReadableLogRecord log) {
    final contextInfo = {};
    if (log.context != null) {
      contextInfo.addAll({
        'traceId': spanContextFromContext(log.context!).traceId,
        'spanId': spanContextFromContext(log.context!).spanId,
        'traceFlags': spanContextFromContext(log.context!).traceFlags,
      });
    }
    return {
      'resource': {
        'attributes': {
          for (final attribute in log.resource?.attributes.keys ?? <String>[])
            attribute: log.resource!.attributes.get(attribute),
        },
      },
      'instrumentationScope': {
        'name': log.instrumentationScope?.name,
        'version': log.instrumentationScope?.version,
        'schemaUrl': log.instrumentationScope?.schemaUrl,
        'attributes': {
          for (final attribute in log.instrumentationScope?.attributes ?? <Attribute>[]) attribute.key: attribute.value,
        }
      },
      'timestamp': log.hrTime,
      'severityText': log.severityText,
      'severityNumber': log.severityNumber,
      'body': log.body,
      'attributes': {
        for (final attribute in log.attributes?.keys ?? <String>[]) attribute: log.resource!.attributes.get(attribute),
      },
      ...contextInfo,
    };
  }
}
