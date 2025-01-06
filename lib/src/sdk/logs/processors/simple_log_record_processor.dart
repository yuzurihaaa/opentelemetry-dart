// Copyright 2021-2022 Workiva.
// Licensed under the Apache License, Version 2.0. Please see https://github.com/Workiva/opentelemetry-dart/blob/master/LICENSE for more information

import 'dart:async';

import 'package:logging/logging.dart' as logging;
import 'package:opentelemetry/src/api/common/export_result.dart';
import 'package:opentelemetry/src/experimental_sdk.dart';

class SimpleLogRecordProcessor implements LogRecordProcessor {
  final logger = logging.Logger('opentelemetry.sdk.logs.simplelogrecordprocessor');
  final LogRecordExporter exporter;
  bool _shutDownOnce = false;
  final _exportsCompletion = <Completer>[];

  SimpleLogRecordProcessor({required this.exporter});

  @override
  void onEmit(LogRecord logRecord) {
    if (_shutDownOnce) return;
    final completer = Completer();
    _exportsCompletion.add(completer);
    exporter.export([logRecord]).then((result) {
      if (result.code != ExportResultCode.success) {
        logger.shout('SimpleLogRecordProcessor: log record export failed', result.error, result.stackTrace);
      }
    }).whenComplete(() {
      completer.complete();
      _exportsCompletion.remove(completer);
    });
  }

  @override
  Future<void> forceFlush() async {
    await Future.forEach(_exportsCompletion, (completer) => completer.future);
  }

  @override
  Future<void> shutdown() async {
    _shutDownOnce = true;
    await exporter.shutdown();
  }
}
