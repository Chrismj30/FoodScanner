import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  if (kIsWeb) {
    dotenv.testLoad(fileInput: 'GEMINI_API_KEY=AIzaSyA91Qu8C8xDq_cpr0zYIhT00UMlUWXD0Lc');
  } else {
    await dotenv.load(fileName: ".env");
  }
  runApp(const MyApp());
}

extension CustomColors on ColorScheme {
  Color get accent => const Color(0xFF00E676);
  Color get neutral => const Color(0xFF9E9E9E);
  Color get success => const Color(0xFF00C853);
  Color get warning => const Color(0xFFFFAB40);
  Color get info => const Color(0xFF40C4FF);
  Color get background => const Color(0xFF121212);
  Color get cardBackground => const Color(0xFF1D1D1D);
  Color get divider => const Color(0xFF323232);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.dark,
          surface: const Color(0xFF121212),
          primary: const Color(0xFF00BFA5),
          secondary: const Color(0xFFFF6E40),
          tertiary: const Color(0xFFFFD54F),
          error: const Color(0xFFFF5252),
          onSurface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onError: Colors.white,
          background: const Color(0xFF121212),
          onBackground: Colors.white,
          surfaceVariant: const Color(0xFF1D1D1D),
          onSurfaceVariant: const Color(0xFFE0E0E0),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1D1D1D),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
