
import '../log_record.dart';

abstract class LogRecordProcessor {
  void onEmit(LogRecord logRecord);

  Future<void> forceFlush();

  Future<void> shutdown();
}
