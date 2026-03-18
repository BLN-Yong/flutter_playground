import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quick_deep_link/deep_link_provider.dart' hide Provider;
import 'package:webview_flutter/webview_flutter.dart';

const _baseUrl =
    'https://bln-rmos-super-app-web-dev-659453389471.asia-southeast1.run.app/';

class DeepLinkEntryPage extends StatefulWidget {
  const DeepLinkEntryPage({super.key});

  @override
  State<DeepLinkEntryPage> createState() => _DeepLinkEntryPageState();
}

class _DeepLinkEntryPageState extends State<DeepLinkEntryPage> {
  late final WebViewController _webViewController;
  StreamSubscription<DeepLinkData>? _deepLinkSubscription;
  DeepLinkData? _latestData;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_baseUrl));

    final deepLinkProvider = Provider.of<DeepLinkProvider>(
      context,
      listen: false,
    );
    _deepLinkSubscription = deepLinkProvider.state.listen((data) {
      _loadDeepLinkUrl(data);
      setState(() => _latestData = data);
    });
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  void _loadDeepLinkUrl(DeepLinkData data) {
    final segments = [
      if (data.page.isNotEmpty) data.page,
      ...data.params,
    ].join('/');

    final url = '$_baseUrl$segments';
    _webViewController.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: _latestData != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: WebViewWidget(controller: _webViewController)),
              ],
            )
          : const Center(
              child: Text(
                'No deep link found',
                style: TextStyle(color: Colors.black),
              ),
            ),
    );
  }
}
