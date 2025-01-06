import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/src/experimental_sdk.dart' as sdk;
import 'package:opentelemetry/src/sdk/common/limits.dart';
import 'package:test/test.dart';

void main() {
  test('test log record limit', () {
    final logLimit = applyAttributeLimitsForLog(
      api.Attribute.fromString('key', 'value'),
      sdk.LogRecordLimits(maxNumAttributeLength: 2),
    );

    expect(logLimit.value, 'va');
  });
}
