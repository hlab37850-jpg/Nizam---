import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage.dart';
import 'core/theme.dart';
import 'services/notifications.dart';
import 'ui/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  await NotificationService.init();
  runApp(const ProviderScope(child: NizamApp()));
}

class NizamApp extends ConsumerWidget {
  const NizamApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nizam OS',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('ar'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}
