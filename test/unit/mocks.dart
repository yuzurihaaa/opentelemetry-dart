// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:opentelemetry/src/api/context/context.dart';
import 'package:opentelemetry/src/api/trace/span.dart';
import 'package:opentelemetry/src/sdk/trace/read_only_span.dart';
import 'package:opentelemetry/src/sdk/trace/span_processors/span_processor.dart';

class MockContext extends Mock implements Context {}

class MockHttpClient extends Mock implements http.Client {}

class MockSpan extends Mock implements Span {}

class MockReadOnlySpan extends Mock implements ReadOnlySpan {}

class MockSpanProcessor extends Mock implements SpanProcessor {}
