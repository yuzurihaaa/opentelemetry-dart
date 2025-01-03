class ExportResult {
  final ExportResultCode code;
  final Exception? error;
  final StackTrace? stackTrace;

  ExportResult({required this.code, this.error, this.stackTrace});
}

enum ExportResultCode {
  success,
  failed,
}
