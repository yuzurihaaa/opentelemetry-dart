class ExportResult {
  final ExportResultCode code;
  final Exception? error;

  ExportResult({required this.code, this.error});
}

enum ExportResultCode {
  success,
  failed,
}
