import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AgnizeApp());
}

class AgnizeApp extends StatelessWidget {
  const AgnizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agnize',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
