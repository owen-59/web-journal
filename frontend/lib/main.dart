import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:frontend/router.dart";
import "package:flutter_web_plugins/url_strategy.dart";

void main() {
  usePathUrlStrategy();
  runApp(ProviderScope(retry: (_, _) => null, child: MainApp()));
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router.config());
  }
}
