import 'package:fixnum/fixnum.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/src/experimental_api.dart' as api;

class LogRecord implements api.LogRecord {
  final api.Severity? _severityNumber;
  final Int64? _timeStamp;
  final Int64? _observedTimestamp;
  final String _severityText;
  final dynamic _logBody;
  final List<Attribute> _attributes;
  final Context _context;

  LogRecord({
    required Context context,
    required String severityText,
    Int64? observedTimestamp,
    Int64? timeStamp,
    api.Severity? severityNumber,
    dynamic logBody,
    List<Attribute> attributes = const <Attribute>[],
  })  : _context = context,
        _severityNumber = severityNumber,
        _timeStamp = timeStamp,
        _observedTimestamp = observedTimestamp,
        _logBody = logBody,
        _attributes = attributes,
        _severityText = severityText;

  @override
  Context? get context => _context;

  @override
  List<Attribute> get attributes => _attributes;

  @override
  dynamic get logBody => _logBody;

  @override
  String get severityText => _severityText;

  @override
  Int64? get observedTimestamp => _observedTimestamp;

  @override
  Int64? get timeStamp => _timeStamp;

  @override
  api.Severity? get severityNumber => _severityNumber;
}
