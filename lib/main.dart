import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quick_deep_link/deep_link_provider.dart' hide Provider;
import 'package:quick_deep_link/deep_link_entry_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DeepLinkProvider bloc = DeepLinkProvider();
    return MaterialApp(
      title: 'Deep link poc',
      theme: ThemeData(colorSchemeSeed: Colors.white),
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
