import 'package:meta/meta.dart';
import 'package:opentelemetry/sdk.dart';
import 'package:opentelemetry/src/api/common/attribute.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/src/sdk/logs/processors/log_record_processor.dart';
import 'package:quiver/core.dart';

const defaultLoggerName = 'unknown';

class LoggerProvider implements api.LoggerProvider {
  @protected
  final Map<int, api.Logger> loggers = {};

  final logRecordProcessors = <LogRecordProcessor>[];

  @override
  api.Logger get(
    String name, {
    String version = '',
    String schemaUrl = '',
    List<Attribute> attributes = const [],
    bool? includeTraceContext,
  }) {
    final loggerName = name.isNotEmpty ? name : defaultLoggerName;
    final key = hash3(loggerName, version, schemaUrl);
    return loggers.putIfAbsent(
      key,
      () => sdk.Logger(
          instrumentationScope: InstrumentationScope(loggerName, version, schemaUrl, attributes),
          onLogEmit: (log) {
            for (final processor in logRecordProcessors) {
              processor.onEmit(log);
            }
          }),
    );
  }

  void addLogRecordProcessor(LogRecordProcessor processor) {
    logRecordProcessors.add(processor);
  }

  Future<void> forceFlush() async {
    await Future.forEach(logRecordProcessors, (e) => e.forceFlush());
  }

  Future<void> shutdown() async {
    await Future.forEach(logRecordProcessors, (e) => e.shutdown());
  }
}
