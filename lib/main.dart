import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_deep_link/deep_link_provider.dart' hide Provider;
import 'package:quick_deep_link/deep_link_entry_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DeepLinkProvider bloc = DeepLinkProvider();
    return MaterialApp(
      title: 'Deep link poc',
      home: Scaffold(
        body: Provider<DeepLinkProvider>(
          create: (context) => bloc,
          dispose: (context, value) => bloc.dispose(),
          child: DeepLinkEntryPage(),
        ),
      ),
    );
  }
}
