# opentelemetry_semantics

OpenTelemetry semantic conventions for Dart: attribute keys and values,
metric names, event names and entity definitions, as Dart enums.

## Usage

```dart
import 'package:opentelemetry_semantics/opentelemetry_semantics.dart';

void main() {
  print(HttpAttributes.httpRequestMethod.key); // http.request.method
  print(HttpMetrics.httpServerRequestDuration.name);
  print(HttpHeaderAttribute.request('content-type').key);
}
```

Every attribute-key enum implements `OTelSemantic`, so your own
app-specific enums can implement it too and mix into the same maps.

## Layout

| Path | Contents |
| --- | --- |
| `lib/src/semantics_base.dart` | the `OTelSemantic`, `OTelMetric`, `OTelEvent` and `OTelEntity` base interfaces |
| `lib/src/semconv/` | generated from the OpenTelemetry semantic-conventions registry — do not edit |
| `lib/src/candidates/` | hand-maintained keys the registry does not define yet; unstable, see [doc/SEMCONV_CANDIDATES.md](doc/SEMCONV_CANDIDATES.md) |

## Regenerating `semconv/`

`lib/src/semconv/` and its audit fixtures in `test/semconv/` are produced by
[OTel Weaver](https://github.com/open-telemetry/weaver) from the registry.
Needs Docker and a
[semantic-conventions](https://github.com/open-telemetry/semantic-conventions)
checkout:

```bash
SEMCONV_REPO=~/dev/semantic-conventions tool/semconv/generate.sh
SEMCONV_REPO=~/dev/semantic-conventions tool/semconv/generate.sh --check
```
