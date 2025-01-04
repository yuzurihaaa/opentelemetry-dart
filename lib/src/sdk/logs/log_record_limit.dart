class LogRecordLimits {
  static const int defaultMaxAttributeCount = 128;
  static const defaultMaxAttributeLength = -1;

  final int maxAttributeCount;
  final int maxNumAttributeLength;

  LogRecordLimits({
    this.maxAttributeCount = defaultMaxAttributeCount,
    this.maxNumAttributeLength = defaultMaxAttributeLength,
  });
}
