import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;

import '../../proto/opentelemetry/proto/collector/logs/v1/logs_service.pb.dart' as pb_logs_service;
import '../../proto/opentelemetry/proto/common/v1/common.pb.dart' as pb_common;
import '../../proto/opentelemetry/proto/logs/v1/logs.pb.dart' as pb_logs;
import '../../proto/opentelemetry/proto/logs/v1/logs.pbenum.dart' as pg_logs_enum;
import '../../proto/opentelemetry/proto/resource/v1/resource.pb.dart' as pb_resource;

class LogCollectorExporter implements sdk.LogRecordExporter {
  final Logger _log = Logger('opentelemetry.LogCollectorExporter');

  final Uri uri;
  final http.Client client;
  final Map<String, String> headers;
  var _isShutdown = false;

  LogCollectorExporter(
    this.uri, {
    http.Client? httpClient,
    this.headers = const {},
  }) : client = httpClient ?? http.Client();

  @override
  Future<api.ExportResult> export(List<sdk.ReadableLogRecord> logRecords) async {
    if (_isShutdown) {
      return api.ExportResult(
        code: api.ExportResultCode.failed,
      );
    }

    if (logRecords.isEmpty) {
      return api.ExportResult(
        code: api.ExportResultCode.success,
      );
    }

    return _send(uri, logRecords).then((_) {
      return api.ExportResult(
        code: api.ExportResultCode.success,
      );
    }).catchError((e, st) {
      return api.ExportResult(
        code: api.ExportResultCode.failed,
        error: e,
        stackTrace: st,
      );
    });
  }

  Future<void> _send(
    Uri uri,
    List<sdk.ReadableLogRecord> logRecords,
  ) async {
    try {
      final body = pb_logs_service.ExportLogsServiceRequest(resourceLogs: _logsToProtobuf(logRecords));

      // final headers = {'Content-Type': 'application/json'}
      //   ..addAll(this.headers);
      // final json = jsonEncode(logRecords);
      final headers = {'Content-Type': 'application/x-protobuf'}..addAll(this.headers);

      await client.post(uri, body: body.writeToBuffer(), headers: headers);
    } catch (e) {
      _log.warning('Failed to export ${logRecords.length} logs.', e);
    }
  }

  @override
  Future<void> shutdown() async {
    _isShutdown = true;
    client.close();
  }

  /// Group and construct the protobuf equivalent of the given list of [api.LogRecord]s.
  /// Logs are grouped by a trace provider's [sdk.Resource] and a tracer's
  /// [sdk.InstrumentationScope].
  Iterable<pb_logs.ResourceLogs> _logsToProtobuf(List<sdk.ReadableLogRecord> logRecords) {
    // use a map of maps to group spans by resource and instrumentation library
    final rsm = <sdk.Resource, Map<sdk.InstrumentationScope, List<pb_logs.LogRecord>>>{};
    for (final logRecord in logRecords) {
      final il = rsm[logRecord.resource] ?? <sdk.InstrumentationScope, List<pb_logs.LogRecord>>{};

      if (logRecord.instrumentationScope != null) {
        il[logRecord.instrumentationScope!] = il[logRecord.instrumentationScope] ?? <pb_logs.LogRecord>[]
          ..add(_logToProtobuf(logRecord));
      }
      if (logRecord.resource != null) {
        rsm[logRecord.resource!] = il;
      }
    }

    final rss = <pb_logs.ResourceLogs>[];
    for (final il in rsm.entries) {
      // for each distinct resource, construct the protobuf equivalent
      final attrs = <pb_common.KeyValue>[];
      for (final attr in il.key.attributes.keys) {
        attrs.add(pb_common.KeyValue(key: attr, value: _attributeValueToProtobuf(il.key.attributes.get(attr)!)));
      }

      final rs = pb_logs.ResourceLogs(resource: pb_resource.Resource(attributes: attrs));
      // for each distinct instrumentation library, construct the protobuf equivalent
      for (final ils in il.value.entries) {
        rs.scopeLogs.add(pb_logs.ScopeLogs(
            logRecords: ils.value,
            scope: pb_common.InstrumentationScope(name: ils.key.name, version: ils.key.version)));
      }
      rss.add(rs);
    }
    return rss;
  }

  pb_logs.LogRecord _logToProtobuf(sdk.ReadableLogRecord log) {
    var spanId = <int>[];
    var traceId = <int>[];
    if (log.spanContext != null) {
      spanId = log.spanContext!.spanId.get();
      traceId = log.spanContext!.traceId.get();
    }
    return pb_logs.LogRecord(
        timeUnixNano: log.hrTime,
        severityNumber: pg_logs_enum.SeverityNumber.valueOf(log.severityNumber!.index),
        body: _attributeONEValueToProtobuf(log.body),
        attributes: (log.attributes?.keys ?? [])
            .map((key) => pb_common.KeyValue(key: key, value: _attributeValueToProtobuf(log.attributes!.get(key)!))),
        spanId: spanId,
        traceId: traceId,
        observedTimeUnixNano: log.hrTimeObserved);
  }

  pb_common.AnyValue _attributeONEValueToProtobuf(Object value) {
    switch (value.runtimeType) {
      case String:
        return pb_common.AnyValue(stringValue: value as String);
      case bool:
        return pb_common.AnyValue(boolValue: value as bool);
      case double:
        return pb_common.AnyValue(doubleValue: value as double);
      case int:
        return pb_common.AnyValue(intValue: Int64(value as int));
    }
    return pb_common.AnyValue();
  }

  pb_common.AnyValue _attributeValueToProtobuf(Object value) {
    switch (value.runtimeType) {
      case String:
        return pb_common.AnyValue(stringValue: value as String);
      case bool:
        return pb_common.AnyValue(boolValue: value as bool);
      case double:
        return pb_common.AnyValue(doubleValue: value as double);
      case int:
        return pb_common.AnyValue(intValue: Int64(value as int));
      case List:
        final list = value as List;
        if (list.isNotEmpty) {
          switch (list[0].runtimeType) {
            case String:
              final values = [] as List<pb_common.AnyValue>;
              for (final str in list) {
                values.add(pb_common.AnyValue(stringValue: str));
              }
              return pb_common.AnyValue(arrayValue: pb_common.ArrayValue(values: values));
            case bool:
              final values = [] as List<pb_common.AnyValue>;
              for (final b in list) {
                values.add(pb_common.AnyValue(boolValue: b));
              }
              return pb_common.AnyValue(arrayValue: pb_common.ArrayValue(values: values));
            case double:
              final values = [] as List<pb_common.AnyValue>;
              for (final d in list) {
                values.add(pb_common.AnyValue(doubleValue: d));
              }
              return pb_common.AnyValue(arrayValue: pb_common.ArrayValue(values: values));
            case int:
              final values = [] as List<pb_common.AnyValue>;
              for (final i in list) {
                values.add(pb_common.AnyValue(intValue: i));
              }
              return pb_common.AnyValue(arrayValue: pb_common.ArrayValue(values: values));
          }
        }
    }
    return pb_common.AnyValue();
  }
}
