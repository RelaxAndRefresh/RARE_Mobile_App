import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const RareApp());
}

class RareApp extends StatelessWidget {
  const RareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RARE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}