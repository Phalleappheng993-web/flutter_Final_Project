import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'theme_state.dart';

class ImagineAiApp extends StatelessWidget {
  const ImagineAiApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: appThemeMode,
    builder: (context, mode, child) => MaterialApp(
      title: 'Imagine AI',
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315BFF)),
        scaffoldBackgroundColor: const Color(0xFFFAFAFC),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F89FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
    ),
  );
}
