import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

abstract class Provider {
  void dispose();
}

class DeepLinkData {
  final String page;
  final List<String> params;

  const DeepLinkData({required this.page, this.params = const []});
}

class DeepLinkProvider extends Provider {
  static const stream = EventChannel('poc.deeplink.flutter.dev/events');

  static const platform = MethodChannel('poc.deeplink.flutter.dev/channel');

  final StreamController<DeepLinkData> _stateController = StreamController();
  Stream<DeepLinkData> get state => _stateController.stream;
  Sink<DeepLinkData> get stateSink => _stateController.sink;

  final _log = Logger("DeepLinkData");

  DeepLinkProvider() {
    startUri().then(_onRedirected);
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  Future<String?> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      _log.severe('Failed to invoke', e.message);
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  void _onRedirected(String? uri) {
    if (uri != null) {
      _log.info("Found the scheme", uri);

      final parsedUri = Uri.parse(uri);
      final segments = parsedUri.pathSegments
          .where((s) => s.isNotEmpty)
          .toList();

      if (segments.isNotEmpty) {
        final page = segments.first;
        final params = segments.sublist(1);
        stateSink.add(DeepLinkData(page: page, params: params));
      }
    }
  }

  @override
  void dispose() {
    _stateController.close();
  }
}
