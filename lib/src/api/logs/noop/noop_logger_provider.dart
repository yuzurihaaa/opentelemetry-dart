import 'package:opentelemetry/src/api/common/attribute.dart';
import 'package:opentelemetry/src/api/logs/log_provider.dart';
import 'package:opentelemetry/src/api/logs/noop/noop_logger.dart';

class NoopLoggerProvider implements LoggerProvider {
  @override
  Logger get(
    String name, {
    String version = '',
    String schemaUrl = '',
    List<Attribute> attributes = const [],
    bool? includeTraceContext,
  }) =>
      NoopLogger();
}
