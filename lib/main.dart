import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // We need a container to read providers before runApp for initialization
  final container = ProviderContainer();
  try {
     await container.read(notificationServiceProvider).init();
  } catch (e) {
     debugPrint('Notification init failed: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Shared Calendar',
      themeMode: ThemeMode.dark, // Force dark mode for now as per user request
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF202124), // Google Cal Dark BG
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8AB4F8), // Google Cal Blue
          secondary: Color(0xFF8AB4F8),
          surface: Color(0xFF202124),
          error: Color(0xFFCF6679),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202124),
          elevation: 0,
        ),
        cardColor: const Color(0xFF303134),
        dialogBackgroundColor: const Color(0xFF303134),
      ),
      routerConfig: router,
    );
  }
}
